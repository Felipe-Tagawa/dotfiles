#!/bin/bash

# Notificação de bateria baixa
# Uso: adicionar ao crontab ou criar um serviço systemd

LOW_BATTERY=20
VERY_LOW_BATTERY=10
CRITICAL_BATTERY=5

while true; do
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

    if [ "$BATTERY_STATUS" = "Discharging" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ]; then
            notify-send -u critical "Bateria Crítica" "Bateria em ${BATTERY_LEVEL}%! Conecte o carregador imediatamente."
        elif [ "$BATTERY_LEVEL" -le "$VERY_LOW_BATTERY" ]; then
            notify-send -u critical "Bateria Muito Baixa" "Bateria em ${BATTERY_LEVEL}%. Conecte o carregador."
        elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY" ]; then
            notify-send -u normal "Bateria Baixa" "Bateria em ${BATTERY_LEVEL}%. Considere conectar o carregador."
        fi
    fi

    sleep 300 # Checar a cada 5 minutos
done