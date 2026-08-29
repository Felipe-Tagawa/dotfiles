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
sudo dnf groupupdate core -y

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf copr enable -y solopasha/hyprland

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ────────────────────────────────────────────────────────────
step "2/6 — Pacotes principais"
# ────────────────────────────────────────────────────────────

sudo dnf groupinstall -y "Development Tools" "Development Libraries"

sudo dnf install -y \
    git wget curl gcc clang golang cmake meson ninja-build \
    pkgconf-pkg-config make fzf jq gawk bison autoconf automake libtool \
    tree gparted xdotool \
    java-17-openjdk java-21-openjdk-devel maven nodejs npm python3-pip \
    mariadb-server \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    freerdp wine virt-host-validate \
    kitty neovim htop btop nvtop mousepad \
    hyprland mpvpaper mpv waybar wlogout wofi rofi dunst \
    cliphist wl-clipboard grim slurp \
    brightnessctl playerctl pamixer pavucontrol \
    network-manager-applet blueman libnotify \
    polkit-kde-authentication-agent-1 \
    qt5ct qt6ct kvantum \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    nitrogen feh swaybg thunar \
    loupe qalculate-gtk cava yad \
    pipewire pipewire-pulseaudio wireplumber pipewire-alsa \
    papirus-icon-theme stow \
    fira-code-fonts jetbrains-mono-fonts fontawesome-fonts \
    ffmpeg imagemagick obs-studio evince mpv-mpris \
    steam epson-inkjet-printer-escpr unrar \
    scrcpy bash-completion \
    || warn "Algum pacote falhou — role a saída acima pra ver qual, e instale manualmente."

step "Spotify (Flatpak, não tem no dnf)"
flatpak install -y flathub com.spotify.Client

# ────────────────────────────────────────────────────────────
step "3/6 — nitch (via cargo, fora do dnf)"
# ────────────────────────────────────────────────────────────

if ! command -v cargo &> /dev/null; then
    warn "cargo não encontrado — instalando Rust via rustup."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

if ! command -v nitch &> /dev/null; then
    cargo install nitch
else
    warn "nitch já instalado, pulando."
fi

warn "PATH precisa incluir \$HOME/.cargo/bin (já está no seu .bashrc)."

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
