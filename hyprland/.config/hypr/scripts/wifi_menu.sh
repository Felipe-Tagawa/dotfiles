#!/bin/bash

# Script para selecionar WiFi via Rofi

# Lista as redes WiFi disponíveis
WIFI_LIST=$(nmcli -t -f ssid,signal,security dev wifi | awk -F: '{print $1 " (" $2 "%)"}')

if [ -z "$WIFI_LIST" ]; then
    notify-send -i network-wireless-disconnected "WiFi" "Nenhuma rede disponível"
    exit 1
fi

# Mostra o menu Rofi
SELECTED_WIFI=$(echo "$WIFI_LIST" | rofi -dmenu -i -p "Selecione a WiFi:" -theme ~/.config/rofi/scripts/cyberpunk.rasi)

if [ -n "$SELECTED_WIFI" ]; then
    # Extrai o SSID (remove tudo após o espaço)
    SSID=$(echo "$SELECTED_WIFI" | awk '{print $1}')

    # Tenta conectar
    notify-send -i network-wireless "WiFi" "Conectando a $SSID..."
    nmcli dev wifi connect "$SSID"

    # Verifica se conectou
    if [ $? -eq 0 ]; then
        notify-send -i network-wireless "WiFi" "Conectado a $SSID"
    else
        notify-send -i network-wireless-error "WiFi" "Falha ao conectar a $SSID"
        # Abre o editor de conexões para configurar
        nm-connection-editor
    fi
fi