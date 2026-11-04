#!/usr/bin/env bash
# Gestao de conexoes Wi-Fi (Menu, Alternancia, Status e Desconexao)
# Uso: wifi.sh [menu|toggle|status|disconnect]

action="${1:-menu}"

case "$action" in
    menu)
        if command -v ronema >/dev/null 2>&1; then
            exec ronema
        elif [ -x "$HOME/.local/bin/ronema" ]; then
            exec "$HOME/.local/bin/ronema"
        else
            exec nm-connection-editor
        fi
        ;;
    toggle)
        status=$(nmcli radio wifi)
        if [ "$status" = "enabled" ]; then
            nmcli radio wifi off
            notify-send -i network-wireless-disconnected "WiFi" "Desativado"
        else
            nmcli radio wifi on
            notify-send -i network-wireless "WiFi" "Ativado"
        fi
        ;;
    status)
        status=$(nmcli radio wifi)
        if [ "$status" = "enabled" ]; then
            ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d':' -f2)
            if [ -n "$ssid" ]; then
                signal=$(nmcli -t -f signal dev wifi 2>/dev/null | head -n 1)
                notify-send -i network-wireless "WiFi" "Conectado: $ssid ($signal%)"
            else
                notify-send -i network-wireless "WiFi" "Ativado - Sem conexão"
            fi
        else
            notify-send -i network-wireless-disconnected "WiFi" "Desativado"
        fi
        ;;
    disconnect)
        wifi_dev=$(nmcli -t -f DEVICE,TYPE dev 2>/dev/null | grep ':wifi$' | cut -d':' -f1 | head -n 1)
        if [ -n "$wifi_dev" ]; then
            nmcli dev disconnect "$wifi_dev"
        else
            nmcli dev disconnect iface wlan0 2>/dev/null
        fi
        notify-send -i network-wireless-disconnected "WiFi" "Desconectado"
        ;;
    *)
        echo "Uso: $0 {menu|toggle|status|disconnect}"
        exit 1
        ;;
esac
