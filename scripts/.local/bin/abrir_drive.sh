#!/usr/bin/env bash

# Feedback visual
clear
if command -v fastfetch &>/dev/null; then
    fastfetch
fi
echo "Iniciando Google Drive no Firefox..."

exec firefox --new-window "https://drive.google.com/drive/my-drive" &
