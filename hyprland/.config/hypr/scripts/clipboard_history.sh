#!/bin/bash

# Script para gerenciar histórico de clipboard com Rofi

if [ "$1" = "copy" ]; then
    # Copiar item do histórico
    cliphist list | rofi -dmenu -i -p "Clipboard:" -theme ~/.config/rofi/scripts/cyberpunk.rasi | cliphist decode | wl-copy
else
    # Mostrar e selecionar do histórico
    cliphist list | rofi -dmenu -i -p "Clipboard:" -theme ~/.config/rofi/scripts/cyberpunk.rasi | cliphist decode | wl-copy
fi