#!/bin/bash

# Usa o tema customizado do clipboard
THEME="$HOME/.config/rofi/clipboard.rasi"

# O parâmetro -display-columns 2 faz o Rofi mostrar apenas o texto copiado, escondendo os IDs do cliphist
cliphist list | rofi -no-config -dmenu -i -display-columns 2 -p "📋" -theme "$THEME" | cliphist decode | wl-copy
