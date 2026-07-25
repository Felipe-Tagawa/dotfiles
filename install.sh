#!/bin/bash

# Cores para o terminal (corrigi o código escape de \034 para \033)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}Iniciando a simbiose dos dotfiles com Stow...${NC}"

# Verificação do Stow
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}Stow não encontrado. Instalando...${NC}"
    sudo apt update && sudo apt install -y stow
fi

# Navegação para o diretório do script
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$DOTFILES_DIR"

# Lista de módulos (removi as vírgulas, bash usa espaços em arrays)
modules=("bash" "autostart" "cinnamon" "fonts" "git" "gtk-3.0" "icons" "kitty" "meta" "nvim" "scripts" "system" "Wallpaper" "waybar")

# Módulos opcionais (só serão instalados se solicitado)
optional_modules=("hyprland")

echo "Linkando módulos..."

for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo -e "Configurando: ${GREEN}$module${NC}"
        # O -R faz o restow (atualiza se já existir)
        stow -R -t "$HOME" "$module"
    else
        echo -e "${YELLOW}Aviso: Pasta '$module' não encontrada. Pulando...${NC}"
    fi
done

# Pós-instalação: Recarregar configurações do Cinnamon se o arquivo existir
if [ -f "$DOTFILES_DIR/cinnamon/dconf-settings.ini" ]; then
    echo -e "${GREEN}Aplicando configurações de interface (dconf)...${NC}"
    dconf load / < "$DOTFILES_DIR/cinnamon/dconf-settings.ini"
fi

# Perguntar sobre módulos opcionais
echo ""
echo -e "${YELLOW}Módulos opcionais disponíveis:${NC}"

if [ -d "hyprland" ]; then
    read -p "Deseja instalar o módulo Hyprland (compositor Wayland)? (s/n): " install_hyprland
    if [[ $install_hyprland =~ ^[SsYy]$ ]]; then
        echo -e "Configurando: ${GREEN}hyprland${NC}"
        stow -R -t "$HOME" "hyprland"
        echo -e "${YELLOW}Nota: Para instalar o Hyprland, execute: cd ~/dotfiles/hyprland && ./install-hyprland.sh${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Pronto! Tudo certo e linkado.${NC}"


