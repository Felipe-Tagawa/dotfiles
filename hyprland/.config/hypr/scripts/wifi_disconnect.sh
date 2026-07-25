#!/bin/bash

# Script para desconectar da WiFi atual

nmcli dev disconnect iface wlan*
notify-send -i network-wireless-disconnected "WiFi" "Desconectado"