#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

step() { echo -e "\n${GREEN}==> $1${NC}"; }
warn() { echo -e "${YELLOW}$1${NC}"; }

if ! command -v dnf &> /dev/null; then
    echo -e "${RED}Este script é para Fedora (precisa do dnf). Abortando.${NC}"
    exit 1
fi

# ────────────────────────────────────────────────────────────
step "1/6 — Repositórios extras (RPM Fusion, Docker, Hyprland COPR)"
# ────────────────────────────────────────────────────────────

sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf group upgrade -y core

sudo dnf -y install dnf-plugins-core
if [ -f /etc/yum.repos.d/docker-ce.repo ]; then
    warn "docker-ce.repo já existe, pulando (rode com --overwrite manualmente se quiser atualizar)."
else
    sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
fi

sudo dnf copr enable -y ashbuk/Hyprland-Fedora

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ────────────────────────────────────────────────────────────
step "2/6 — Pacotes principais"
# ────────────────────────────────────────────────────────────

sudo dnf group install -y development-tools development-libs

sudo dnf install -y \
    git wget curl gcc clang golang cmake meson ninja-build \
    pkgconf-pkg-config make fzf jq gawk bison autoconf automake libtool \
    tree gparted xdotool \
    java-25-openjdk java-25-openjdk-devel maven nodejs npm python3-pip \
    mariadb-server \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    freerdp wine virt-host-validate \
    kitty neovim htop btop nvtop mousepad \
    hyprland mpv waybar wlogout wofi rofi dunst \
    cliphist wl-clipboard grim slurp \
    brightnessctl playerctl pamixer pavucontrol \
    network-manager-applet blueman libnotify \
    polkit-kde \
    qt5ct qt6ct kvantum \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    nitrogen feh swaybg thunar \
    loupe qalculate-gtk cava yad \
    pipewire pipewire-pulseaudio wireplumber pipewire-alsa \
    papirus-icon-theme stow \
    fira-code-fonts jetbrains-mono-fonts fontawesome-fonts \
    ImageMagick obs-studio evince mpv-mpris \
    steam unrar \
    bash-completion \
    || warn "Algum pacote falhou — role a saída acima pra ver qual, e instale manualmente."

step "ffmpeg completo (RPM Fusion) no lugar do ffmpeg-free"
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing \
    || warn "Não deu pra trocar o ffmpeg — o ffmpeg-free (Fedora) continua instalado, sem alguns codecs."

step "mpvpaper e scrcpy (não estão no COPR do Hyprland, cada um tem o seu)"
sudo dnf copr enable -y ashbuk/Hyprland-Fedora >/dev/null 2>&1
sudo dnf install -y mpvpaper \
    || warn "mpvpaper não encontrado nesse COPR — instale manualmente depois."
sudo dnf copr enable -y zeno/scrcpy || warn "Não deu pra habilitar o COPR zeno/scrcpy."
sudo dnf install -y scrcpy \
    || warn "scrcpy falhou — confira o COPR zeno/scrcpy manualmente."
warn "epson-inkjet-printer-escpr não foi instalado: o pacote está órfão no Fedora 44 (só relevante se você tiver uma impressora Epson específica). Baixe o driver direto do site da Epson se precisar."

step "Spotify (Flatpak, não tem no dnf)"
flatpak install -y flathub com.spotify.Client

# ────────────────────────────────────────────────────────────
step "3/6 — fastfetch (system info, no lugar do nitch — mais customizável)"
# ────────────────────────────────────────────────────────────

if ! command -v fastfetch &> /dev/null; then
    sudo dnf install -y fastfetch
    fastfetch --gen-config
    warn "fastfetch instalado. Config gerada em ~/.config/fastfetch/config.jsonc — edite pra customizar módulos, cores e ícones."
else
    warn "fastfetch já instalado, pulando."
fi

# ────────────────────────────────────────────────────────────
step "4/6 — Serviços"
# ────────────────────────────────────────────────────────────

sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
warn "Você precisa deslogar/logar de novo pra rodar docker sem sudo."

# ────────────────────────────────────────────────────────────
step "5/6 — Dotfiles"
# ────────────────────────────────────────────────────────────

if [ ! -d "$HOME/dotfiles" ]; then
    read -p "Ainda não achei ~/dotfiles. Clonar do GitHub agora? (s/n): " clone_now
    if [[ $clone_now =~ ^[SsYy]$ ]]; then
        git clone https://github.com/Felipe-Tagawa/dotfiles.git "$HOME/dotfiles"
    fi
fi

if [ -d "$HOME/dotfiles" ]; then
    cd "$HOME/dotfiles"
    if [ -f "./install.sh" ]; then
        ./install.sh
    else
        warn "install.sh não encontrado em ~/dotfiles."
    fi
else
    warn "Pulei a etapa de dotfiles — rode manualmente depois."
fi

# ────────────────────────────────────────────────────────────
step "6/6 — Pronto"
# ────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}Bootstrap concluído.${NC}"
echo "Coisas pra conferir manualmente:"
echo "  - Reinicie a máquina antes de usar o Docker/grupo docker."
echo "  - Escolha/configure o display manager e a sessão Hyprland você mesmo (sem SDDM aqui)."
echo "  - O wallpaper em vídeo precisa do exec-once do mpvpaper no hyprland.conf"
echo "    (ex: exec-once = mpvpaper -o \"no-audio loop\" '*' ~/Pictures/Wallpapers/seu-video.mp4)"
echo "  - PostgreSQL não foi instalado aqui — instale/configure manualmente se for usar."
echo "  - MariaDB não é iniciado automaticamente aqui — rode 'sudo systemctl enable --now mariadb' se for usar."
echo "  - fastfetch: personalize em ~/.config/fastfetch/config.jsonc (rode 'fastfetch --gen-config' de novo se quiser resetar)."
echo "  - Se mpvpaper ou scrcpy falharam na instalação, role a saída lá em cima pra ver o motivo."
