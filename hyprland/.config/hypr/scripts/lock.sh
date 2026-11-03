#!/usr/bin/env bash
# Screen Locker Script
# Prefers hyprlock (native for Hyprland), fallback to gtklock / swaylock

# Avoid multiple instances
if pidof hyprlock >/dev/null || pidof gtklock >/dev/null || pidof swaylock >/dev/null; then
    exit 0
fi

if command -v hyprlock &>/dev/null; then
    exec hyprlock
elif command -v gtklock &>/dev/null; then
    IMAGE=/tmp/screen_lock.png
    if grim "$IMAGE" 2>/dev/null; then
        convert "$IMAGE" -blur 0x8 "$IMAGE" 2>/dev/null
        gtklock -b "$IMAGE"
        rm -f "$IMAGE"
    else
        exec gtklock
    fi
elif command -v swaylock &>/dev/null; then
    exec swaylock -f -c 1e1e2e
else
    notify-send -u critical "Locker" "Nenhum bloqueador de tela disponível (instale hyprlock ou gtklock)."
fi
