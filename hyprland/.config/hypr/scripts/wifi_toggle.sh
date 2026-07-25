#!/bin/bash

# Script para toggle WiFi com notificação

WIFI_STATUS=$(nmcli radio wifi)

if [ "$WIFI_STATUS" = "enabled" ]; then
    nmcli radio wifi off
    notify-send -i network-wireless-disconnected "WiFi" "Desativado"
else
    nmcli radio wifi on
    notify-send -i network-wireless "WiFi" "Ativado"
fi