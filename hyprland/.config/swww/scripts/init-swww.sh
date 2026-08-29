#!/bin/bash

# Define a imagem
WALLPAPER="$HOME/dotfiles/Wallpaper/Pictures/Wallpapers/musashi.png"

# Inicia o daemon do swww se ele não estiver rodando (desconectando do terminal)
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon >/dev/null 2>&1 &
    sleep 0.5
fi

# Aplica o wallpaper
swww img "$WALLPAPER" --transition-type random --transition-fps 60 >/dev/null 2>&1 &
