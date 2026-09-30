#!/bin/bash

# Alterna o HDMI-A-1 entre modo estendido (uso normal com dois monitores)
# e modo espelhado (pra quando for projetar e não quiser ficar olhando
# pra tela preta enquanto o conteúdo aparece só no projetor)

STATE_FILE="/tmp/hypr-projetor-state"

# Se o arquivo de estado não existe, assume que está em modo estendido
if [ ! -f "$STATE_FILE" ]; then
    echo "estendido" > "$STATE_FILE"
fi

MODO_ATUAL=$(cat "$STATE_FILE")

if [ "$MODO_ATUAL" = "estendido" ]; then
    # Muda pra espelhado: HDMI passa a reproduzir exatamente o eDP-1
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1,mirror,eDP-1"
    echo "espelhado" > "$STATE_FILE"
    notify-send "Projeção" "Modo espelhado ativado" 2>/dev/null
else
    # Volta pro estendido, igual sua config original
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,auto,1"
    echo "estendido" > "$STATE_FILE"
    notify-send "Projeção" "Modo estendido ativado" 2>/dev/null
fi
