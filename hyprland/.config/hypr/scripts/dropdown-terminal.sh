#!/usr/bin/env bash
# Alterna ou inicia o terminal dropdown no scratchpad

if ! hyprctl clients | grep -q "class: dropdown-terminal"; then
    kitty --class dropdown-terminal &
    sleep 0.15
fi

hyprctl dispatch togglespecialworkspace scratchpad
