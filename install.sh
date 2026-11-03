#!/usr/bin/env bash
# Dotfiles Installer & Symlink Manager (GNU Stow)
# Fedora 44 & Hyprland 0.56+

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME"
ACTION="-R" # Default: restow
DRY_RUN=""
SPECIFIC_MODULE=""

# Module List (in load order)
MODULES=(
    "bash"
    "git"
    "hyprland"
    "kitty"
    "nvim"
    "rofi"
    "fastfetch"
    "gtk-3.0"
    "gtk-4.0"
    "waybar"
    "fonts"
    "scripts"
    "system"
    "Wallpaper"
    "icons"
    "themes"
    "matugen"
    "wlogout"
    "swaync"
    "swayosd"
)

usage() {
    echo "Uso: $0 [opções]"
    echo ""
    echo "Opções:"
    echo "  -r, --restow       Atualiza e recria todos os symlinks (padrão)"
    echo "  -d, --delete       Remove os symlinks gerenciados pelo Stow"
    echo "  -n, --dry-run      Simula a execução sem fazer alterações"
    echo "  -m, --module NOME  Executa apenas para o módulo especificado"
    echo "  -h, --help         Exibe esta ajuda"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--restow)
            ACTION="-R"
            shift
            ;;
        -d|--delete)
            ACTION="-D"
            shift
            ;;
        -n|--dry-run)
            DRY_RUN="-n -v"
            shift
            ;;
        -m|--module)
            SPECIFIC_MODULE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Opção inválida: $1${NC}"
            usage
            ;;
    esac
done

echo -e "${BLUE}Gerenciador de Dotfiles (GNU Stow)${NC}"
echo -e "Diretório de Dotfiles: ${GREEN}$DOTFILES_DIR${NC}"
echo -e "Destino (HOME):        ${GREEN}$TARGET_DIR${NC}"
echo ""

# Ensure GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}GNU Stow não encontrado. Tentando instalar...${NC}"
    if command -v dnf5 &> /dev/null; then
        sudo dnf5 install -y stow
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y stow
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm stow
    else
        echo -e "${RED}Gerenciador de pacotes não identificado. Instale 'stow' manualmente.${NC}"
        exit 1
    fi
fi

cd "$DOTFILES_DIR"

# Pre-backup helper for files that might conflict (e.g. real ~/.bashrc instead of symlink)
backup_if_real_file() {
    local file="$1"
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        local bak="${file}.bak_$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}Arquivo existente não é symlink: $file -> Backup em $bak${NC}"
        mv "$file" "$bak"
    fi
}

# Check known conflicts before stowing
if [ "$ACTION" = "-R" ] && [ -z "$DRY_RUN" ]; then
    backup_if_real_file "$HOME/.bashrc"
    backup_if_real_file "$HOME/.gitconfig"
    backup_if_real_file "$HOME/.profile"
fi

# Process modules
TARGET_MODULES=()
if [ -n "$SPECIFIC_MODULE" ]; then
    TARGET_MODULES=("$SPECIFIC_MODULE")
else
    TARGET_MODULES=("${MODULES[@]}")
fi

echo -e "${GREEN}Processando módulos...${NC}"
for mod in "${TARGET_MODULES[@]}"; do
    if [ -d "$DOTFILES_DIR/$mod" ]; then
        echo -ne "  [+] Módulo ${BLUE}$mod${NC}... "
        if stow $ACTION $DRY_RUN -t "$TARGET_DIR" "$mod" 2>/dev/null; then
            echo -e "${GREEN}OK${NC}"
        else
            # Try with adopt or report warning
            echo -e "${YELLOW}Tentando com --adopt...${NC}"
            stow $ACTION $DRY_RUN --adopt -t "$TARGET_DIR" "$mod" || echo -e "${RED}Erro ao processar $mod${NC}"
        fi
    else
        echo -e "  [-] Módulo ${YELLOW}$mod${NC} não encontrado no repositório. Pulando."
    fi
done

# Verification
echo ""
echo -e "${GREEN}Concluído com sucesso!${NC}"
if command -v Hyprland &>/dev/null; then
    echo -e "${BLUE}Verificando sintaxe do Hyprland...${NC}"
    VERIFY_OUTPUT=$(Hyprland --verify-config 2>&1 || true)
    if echo "$VERIFY_OUTPUT" | grep -q "config ok"; then
        echo -e "  [+] ${GREEN}Configuração do Hyprland 100% válida (OK)${NC}"
    else
        echo "$VERIFY_OUTPUT" | grep -v "Socket2" | grep -E "(ERR|WARN)" || true
    fi
fi
