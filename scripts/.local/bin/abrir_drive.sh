#!/bin/bash

# Feedback visual com seu nitch
clear
nitch
echo "Iniciando Google Drive PWA..."

# Abre o Drive como Web App
vivaldi-stable --app=https://drive.google.com/drive/my-drive &

# Espera o carregamento
sleep 4

# Foca na janela usando o xdotool
WID=$(xdotool search --onlyvisible --class "drive.google.com" | head -1)

if [ -n "$WID" ]; then
    xdotool windowactivate $WID
    echo "Drive em foco!"
else
    echo "Erro: Janela do Drive não encontrada."
fi
