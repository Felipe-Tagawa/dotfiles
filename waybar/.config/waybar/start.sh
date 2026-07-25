#!/bin/bash
pkill waybar 2>/dev/null
sleep 0.3

THEME_DIR=$(readlink -f ~/.config/waybar/current)
CONFIG_FILE=$(find "$THEME_DIR" -maxdepth 1 -name "config*" | head -1)
STYLE_FILE=$(find "$THEME_DIR" -maxdepth 1 -name "style*" | head -1)

waybar -c "$CONFIG_FILE" -s "$STYLE_FILE" &
disown
