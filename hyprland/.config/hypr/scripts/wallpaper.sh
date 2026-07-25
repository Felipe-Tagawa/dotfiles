#!/bin/bash

# Finaliza instâncias antigas rápido
killall swww-daemon 2>/dev/null
mkdir -p /home/kyo/.cache/swww

# Inicializa o daemon imediatamente no boot
swww-daemon --no-cache &

# Espera mínima apenas para o socket abrir
sleep 0.3

# Aplica a imagem instantaneamente sem transição lenta
swww img /home/kyo/Pictures/Wallpapers/musashi.png --transition-type none
