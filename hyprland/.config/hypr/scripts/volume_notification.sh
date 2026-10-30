#!/bin/bash

# Notificação e controle de volume (SwayOSD com fallback para pactl + notify-send)
# Uso: volume_notification.sh [up|down|mute]

if command -v swayosd-client >/dev/null 2>&1; then
    case $1 in
        up)
            swayosd-client --output-volume raise 5
            ;;
        down)
            swayosd-client --output-volume lower 5
            ;;
        mute)
            swayosd-client --output-volume mute-toggle
            ;;
    esac
    exit 0
fi

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1
}

is_muted() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"
    echo $?
}

case $1 in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

VOLUME=$(get_volume)
MUTED_STATUS=$(is_muted)

if [ "$MUTED_STATUS" -eq 0 ]; then
    notify-send -h int:value:0 -h string:synchronous:volume "Volume" "Mudo" -t 2000
else
    notify-send -h int:value:$VOLUME -h string:synchronous:volume "Volume" "${VOLUME}%" -t 2000
fi