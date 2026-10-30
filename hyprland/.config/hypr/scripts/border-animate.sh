#!/bin/bash
# =============================================================================
# Hyprland Border Animation Daemon
# Rotates active gradient borders dynamically based on current_theme.lua
# =============================================================================

THEME_FILE="$HOME/.config/hypr/current_theme.lua"
angle=0

while true; do
    if [ -f "$THEME_FILE" ]; then
        c1=$(grep 'active_1' "$THEME_FILE" | head -n1 | cut -d'"' -f2)
        c2=$(grep 'active_2' "$THEME_FILE" | head -n1 | cut -d'"' -f2)
        c3=$(grep 'active_3' "$THEME_FILE" | head -n1 | cut -d'"' -f2)
        [ -z "$c3" ] && c3="$c1"
    else
        c1="0xffcba6f7"
        c2="0xffb4befe"
        c3="0xfff5c2e7"
    fi

    [ -z "$c1" ] && c1="0xffcba6f7"
    [ -z "$c2" ] && c2="0xffb4befe"
    [ -z "$c3" ] && c3="$c1"

    # Rotaciona o ângulo do degradê a cada ciclo
    angle=$(( (angle + 45) % 360 ))

    hyprctl eval "hl.config({ general = { col = { active_border = { colors = { '${c1}', '${c2}', '${c3}' }, angle = ${angle} } } } })" >/dev/null 2>&1

    sleep 2
done
