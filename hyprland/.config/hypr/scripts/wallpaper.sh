#!/bin/bash

# Executa todo o processo em background isolado para não prender o DBus/Hyprland
(
    # Finaliza instâncias antigas rápido
    killall swww-daemon 2>/dev/null
    mkdir -p "$HOME/.cache/swww"

    # Inicializa o daemon imediatamente no boot
    swww-daemon --no-cache >/dev/null 2>&1 &

    # Espera mínima apenas para o socket abrir
    sleep 0.3

    # Aplica a imagem instantaneamente sem transição lenta
    swww img "$HOME/Pictures/Wallpapers/hunter.png" --transition-type none >/dev/null 2>&1
) &
