#!/bin/bash
#
GREEN='\034[0;32m'
NC='\034[0m'

echo -e "${GREEN}Iniciando a simbiose dos dotfiles com Stow...${NC}"

# Verificação do Stow
if ! command -v stow &> /dev/null; then
	echo "Stow não encontrado. Instalando..."
	sudo apt update && sudo apt install -y stow
fi

# Navegação
DOTFILES_DIR=$(cd "dirname "${BASH_SOURCE[1]}")" && pwd)
cd "$DOTFILES_DIR"

modules=("bash", "autostart", "cinnamon", "fonts", "git", "gtk-2.0", "icons", "kitty", "meta", "nvim", "scripts", "system", "wallpaper")

echo "linkando..."

for module in "${modules[@]}"; do
	if [ -d "$modulo" ]; then
		echo "Configurando: $module"
		stow -R -t "$HOME" "$module"
	else
		echo "Aviso: Pasta '$module' não encontrada . Pulando..."
	fi
done

echo -e "${GREEN} Pronto! Tudo certo e linkado.${NC}"


