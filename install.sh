#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Iniciando a simbiose dos dotfiles com Stow...${NC}"

# Verificação do Stow — detecta o gerenciador de pacotes da distro
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}Stow não encontrado. Instalando...${NC}"
    if command -v dnf &> /dev/null; then
        sudo dnf install -y stow
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y stow
    else
        echo -e "${RED}Não consegui detectar dnf nem apt. Instale o Stow manualmente e rode o script de novo.${NC}"
        exit 1
    fi
fi

# Navegação para o diretório do script
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$DOTFILES_DIR"

# Lista de módulos
# Corrigido: "icons" -> ".icons" (a pasta no repo tem ponto na frente)
# Adicionados: ".themes", "vicinae", "vicinae-config" (existiam no repo mas
# nunca eram stowados porque não estavam nesta lista)
modules=(
    "bash"
    "autostart"
    "cinnamon"
    "fonts"
    "git"
    "gtk-3.0"
    ".icons"
    ".themes"
    "kitty"
    "meta"
    "nvim"
    "scripts"
    "system"
    "Wallpaper"
    "waybar"
    "vicinae"
    "vicinae-config"
)

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
# (só faz sentido se você continuar usando Cinnamon no Fedora; se migrar
# para Hyprland/outro DE, esse bloco simplesmente não faz nada)
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
