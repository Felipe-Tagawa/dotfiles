#!/bin/bash

# Inicializa o swww com o wallpaper musashi.png
swww init &
sleep 1

swww img "$HOME/dotfiles/Wallpaper/Pictures/Wallpapers/musashi.png" --transition-type random --transition-fps 60
