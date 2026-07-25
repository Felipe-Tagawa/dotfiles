#!/bin/bash

# Script para mostrar status atual da WiFi

WIFI_STATUS=$(nmcli radio wifi)

if [ "$WIFI_STATUS" = "enabled" ]; then
    CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d':' -f2)
    if [ -n "$CURRENT_SSID" ]; then
        SIGNAL=$(nmcli -t -f signal dev wifi | head -1)
        notify-send -i network-wireless "WiFi" "Conectado: $CURRENT_SSID ($SIGNAL%)"
    else
        notify-send -i network-wireless "WiFi" "Ativado - Sem conexão"
    fi
else
    notify-send -i network-wireless-disconnected "WiFi" "Desativado"
fi