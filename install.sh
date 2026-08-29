#!/bin/bash
set -e

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$DOTFILES_DIR"

echo -e "${GREEN}Iniciando a simbiose dos dotfiles...${NC}"

# ─── 1. Detecção de distro ──────────────────────────────────────────
# Usa /etc/os-release (padrão em qualquer distro moderna) em vez de
# assumir apt. ID_LIKE cobre derivadas (ex: Mint reporta ID=linuxmint,
# ID_LIKE=ubuntu debian).
if [ ! -f /etc/os-release ]; then
    echo -e "${RED}Não encontrei /etc/os-release. Não consigo detectar a distro.${NC}"
    exit 1
fi
. /etc/os-release

PKG_MANAGER=""
if command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
else
    echo -e "${RED}Nenhum gerenciador de pacotes suportado encontrado (dnf ou apt).${NC}"
    echo -e "${YELLOW}Pulei a instalação de pacotes. Só vou linkar as configs.${NC}"
fi

echo -e "Distro detectada: ${GREEN}${PRETTY_NAME:-desconhecida}${NC} (gerenciador: ${GREEN}${PKG_MANAGER:-nenhum}${NC})"
echo ""

# ─── 2. Instalação de pacotes nativos ───────────────────────────────
install_native_packages() {
    local list_file=""
    case "$PKG_MANAGER" in
        apt) list_file="$DOTFILES_DIR/meta/packages-apt.txt" ;;
        dnf) list_file="$DOTFILES_DIR/meta/packages-dnf.txt" ;;
        *) return 0 ;;
    esac

    if [ ! -f "$list_file" ]; then
        echo -e "${YELLOW}Lista de pacotes não encontrada: $list_file${NC}"
        return 0
    fi

    # Remove comentários (#) e linhas vazias, joga o resto num array
    local packages=()
    while IFS= read -r line; do
        line="${line%%#*}"          # remove comentário no fim da linha
        line="$(echo -n "$line" | xargs)"  # trim de espaços
        [ -n "$line" ] && packages+=("$line")
    done < "$list_file"

    if [ "${#packages[@]}" -eq 0 ]; then
        echo -e "${YELLOW}Nenhum pacote pra instalar em $list_file${NC}"
        return 0
    fi

    echo -e "${GREEN}Instalando ${#packages[@]} pacotes via $PKG_MANAGER...${NC}"
    case "$PKG_MANAGER" in
        apt)
            sudo apt update
            sudo apt install -y "${packages[@]}"
            ;;
        dnf)
            sudo dnf install -y "${packages[@]}"
            ;;
    esac
}

read -p "Instalar pacotes nativos ($PKG_MANAGER) da lista curada? (s/n): " do_native
if [[ $do_native =~ ^[SsYy]$ ]] && [ -n "$PKG_MANAGER" ]; then
    install_native_packages
else
    echo -e "${YELLOW}Pulando instalação de pacotes nativos.${NC}"
fi
echo ""

# ─── 3. Flatpaks (mesmos apps em qualquer distro) ───────────────────
install_flatpaks() {
    local list_file="$DOTFILES_DIR/meta/flatpak-apps.txt"
    if [ ! -f "$list_file" ]; then
        return 0
    fi

    if ! command -v flatpak &> /dev/null; then
        echo -e "${YELLOW}Flatpak não encontrado. Instalando...${NC}"
        case "$PKG_MANAGER" in
            apt) sudo apt install -y flatpak ;;
            dnf) sudo dnf install -y flatpak ;;
            *) echo -e "${RED}Não sei instalar o Flatpak nesse sistema. Pulando.${NC}"; return 1 ;;
        esac
    fi

    if ! flatpak remote-list | grep -q flathub; then
        echo -e "${GREEN}Adicionando o repositório Flathub...${NC}"
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    local apps=()
    while IFS= read -r line; do
        line="${line%%#*}"
        line="$(echo -n "$line" | xargs)"
        [ -n "$line" ] && apps+=("$line")
    done < "$list_file"

    if [ "${#apps[@]}" -eq 0 ]; then
        return 0
    fi

    echo -e "${GREEN}Instalando ${#apps[@]} apps via Flatpak...${NC}"
    flatpak install -y flathub "${apps[@]}"
}

read -p "Instalar apps via Flatpak (Vivaldi, VSCode, Heroic, etc.)? (s/n): " do_flatpak
if [[ $do_flatpak =~ ^[SsYy]$ ]]; then
    install_flatpaks
else
    echo -e "${YELLOW}Pulando instalação de Flatpaks.${NC}"
fi
echo ""

# ─── 4. Stow (linkar configs) ───────────────────────────────────────
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}Stow não encontrado. Instalando...${NC}"
    case "$PKG_MANAGER" in
        apt) sudo apt install -y stow ;;
        dnf) sudo dnf install -y stow ;;
        *) echo -e "${RED}Instale o Stow manualmente e rode este script de novo.${NC}"; exit 1 ;;
    esac
fi

modules=("bash" "autostart" "cinnamon" "fonts" "git" "gtk-3.0" "icons" "kitty" "meta" "nvim" "scripts" "system" "Wallpaper" "waybar")
optional_modules=("hyprland")

echo "Linkando módulos..."
for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo -e "Configurando: ${GREEN}$module${NC}"
        stow -R -t "$HOME" "$module"
    else
        echo -e "${YELLOW}Aviso: Pasta '$module' não encontrada. Pulando...${NC}"
    fi
done

# ─── 5. Pós-instalação: dconf do Cinnamon ───────────────────────────
if [ -f "$DOTFILES_DIR/cinnamon/dconf-settings.ini" ] && command -v dconf &> /dev/null; then
    echo -e "${GREEN}Aplicando configurações de interface (dconf)...${NC}"
    dconf load / < "$DOTFILES_DIR/cinnamon/dconf-settings.ini"
fi

# ─── 6. Módulos opcionais ────────────────────────────────────────────
echo ""
echo -e "${YELLOW}Módulos opcionais disponíveis:${NC}"
if [ -d "hyprland" ]; then
    read -p "Deseja instalar o módulo Hyprland (compositor Wayland)? (s/n): " install_hyprland
    if [[ $install_hyprland =~ ^[SsYy]$ ]]; then
        echo -e "Configurando: ${GREEN}hyprland${NC}"
        stow -R -t "$HOME" "hyprland"

        if [ "$PKG_MANAGER" = "dnf" ]; then
            echo -e "${GREEN}No Fedora, o Hyprland está nos repositórios oficiais.${NC}"
            read -p "Instalar Hyprland + Waybar agora via dnf? (s/n): " install_hypr_dnf
            if [[ $install_hypr_dnf =~ ^[SsYy]$ ]]; then
                sudo dnf install -y hyprland waybar
            fi
        elif [ -f "$DOTFILES_DIR/hyprland/install-hyprland.sh" ]; then
            echo -e "${YELLOW}No Ubuntu/Mint o Hyprland não vem no apt padrão.${NC}"
            echo -e "${YELLOW}Rode: cd $DOTFILES_DIR/hyprland && ./install-hyprland.sh${NC}"
        fi
    fi
fi

# ─── 7. Avisos manuais (coisas que não dá pra automatizar com segurança) ─
echo ""
echo -e "${YELLOW}━━━ Passos manuais pendentes ━━━${NC}"
if [ "$PKG_MANAGER" = "dnf" ]; then
    echo "• Driver NVIDIA: precisa do RPM Fusion (free + nonfree) + akmod-nvidia."
    echo "  Ver: https://rpmfusion.org/Configuration"
    echo "• Ambiente Cinnamon completo (se não estiver usando a Cinnamon Spin):"
    echo "  sudo dnf group install \"Cinnamon Desktop\""
    echo "• Docker: precisa adicionar o repositório oficial antes do dnf install."
    echo "  Ver: https://docs.docker.com/engine/install/fedora/"
    echo "• MongoDB Compass: se preferir o pacote oficial em vez do Flatpak, ver"
    echo "  https://www.mongodb.com/try/download/compass"
fi

echo ""
echo -e "${GREEN}Pronto! Tudo certo e linkado.${NC}"

