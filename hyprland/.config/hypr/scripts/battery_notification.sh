#!/bin/bash

LOW_BATTERY=20
VERY_LOW_BATTERY=10
CRITICAL_BATTERY=5

# Variáveis para evitar notificações repetidas
notified_low=false
notified_very_low=false
notified_critical=false

while true; do
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

    if [ "$BATTERY_STATUS" = "Discharging" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ] && [ "$notified_critical" = false ]; then
            notify-send -u critical "Bateria Crítica" "Bateria em ${BATTERY_LEVEL}%!"
            notified_critical=true
        elif [ "$BATTERY_LEVEL" -le "$VERY_LOW_BATTERY" ] && [ "$notified_very_low" = false ]; then
            notify-send -u critical "Bateria Muito Baixa" "Bateria em ${BATTERY_LEVEL}%."
            notified_very_low=true
        elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY" ] && [ "$notified_low" = false ]; then
            notify-send -u normal "Bateria Baixa" "Bateria em ${BATTERY_LEVEL}%."
            notified_low=true
        fi
    else
        # Se conectou na tomada, reseta os avisos
        notified_low=false
        notified_very_low=false
        notified_critical=false
    fi

    sleep 120 # Checar a cada 2 minutos
done
