#!/bin/bash

# Cores Catppuccin Mocha em hexadecimal (formato ARGB do Hyprland)
mauve="0xffcba6f7"
lavender="0xffb4befe"
sapphire="0xff74c7ec"
pink="0xfff5c2e7"

# Array com as combinações de cores para o degradê animado
colors=(
    "$mauve $lavender"
    "$lavender $sapphire"
    "$sapphire $pink"
    "$pink $mauve"
)

i=0
while true; do
    hyprctl keyword general:col.active_border "${colors[$i]} 45deg"
    i=$(( (i + 1) % ${#colors[@]} ))
    sleep 2
done
