#!/usr/bin/env bash
# Hyprlock status helper (Battery & Time/Date)

BAT_PATH="/sys/class/power_supply/BAT1"
if [ ! -d "$BAT_PATH" ]; then
    BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" 2>/dev/null | head -n 1)
fi

if [ -n "$BAT_PATH" ] && [ -d "$BAT_PATH" ]; then
    capacity=$(cat "$BAT_PATH/capacity" 2>/dev/null || echo "100")
    status=$(cat "$BAT_PATH/status" 2>/dev/null || echo "Unknown")
    
    if [ "$status" = "Charging" ]; then
        icon="󰂄"
    elif [ "$capacity" -ge 90 ]; then
        icon="󰁹"
    elif [ "$capacity" -ge 70 ]; then
        icon="󰂀"
    elif [ "$capacity" -ge 50 ]; then
        icon="󰁾"
    elif [ "$capacity" -ge 20 ]; then
        icon="󰁼"
    else
        icon="󰂃"
    fi
    echo "$icon  ${capacity}%"
else
    echo "󰌌  $(whoami)"
fi
