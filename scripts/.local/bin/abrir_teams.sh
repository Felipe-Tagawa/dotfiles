#!/bin/bash

# Abre o Teams em modo Janela (PWA)
vivaldi-stable --app=https://teams.cloud.microsoft &

# Espera 4 segundos para o carregamento pesado do Teams
sleep 4

# Procura a janela específica do Teams PWA e coloca em foco
WID=$(xdotool search --onlyvisible --class "teams.cloud.microsoft" | head -1)

# Se ele achar a janela, ativa ela e dá um "Enter" caso esteja na tela de 'Join'
if [ [ -n "$WID" ] ]; then
    xdotool windowactivate $WID
    # Opcional: xdotool key Return
fi
