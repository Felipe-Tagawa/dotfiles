#!/bin/bash

# Notificação e controle de brilho (SwayOSD com fallback para brightnessctl + notify-send)
# Uso: brightness_notification.sh [up|down]

if command -v swayosd-client >/dev/null 2>&1; then
    case $1 in
        up)
            swayosd-client --brightness raise 5
            ;;
        down)
            swayosd-client --brightness lower 5
            ;;
    esac
    exit 0
fi

get_brightness() {
    brightnessctl get | awk '{print int($1)}'
}

get_max_brightness() {
    brightnessctl max | awk '{print int($1)}'
}

calculate_percentage() {
    local current=$(get_brightness)
    local max=$(get_max_brightness)
    echo $((current * 100 / max))
}

case $1 in
    up)
        brightnessctl set +5%
        ;;
    down)
        brightnessctl set 5%-
        ;;
esac

BRIGHTNESS=$(calculate_percentage)
notify-send -h int:value:$BRIGHTNESS -h string:synchronous:brightness "Brilho" "${BRIGHTNESS}%" -t 2000