#!/bin/bash

# Script para testar todas as notificações

echo "Testando sistema de notificações..."
echo ""

# Testar diferentes urgencias
notify-send -u critical "Critico" "Alerta critico de teste!"
sleep 1
notify-send -u normal "Normal" "Notificacao normal de teste!"
sleep 1
notify-send -u low "Baixa" "Notificacao de baixa urgencia!"
sleep 1

# Testar volume
echo "Testando notificação de volume..."
~/.config/hypr/scripts/volume_notification.sh up
sleep 2
~/.config/hypr/scripts/volume_notification.sh down
sleep 2

# Testar brilho
echo "Testando notificação de brilho..."
~/.config/hypr/scripts/brightness_notification.sh up
sleep 2
~/.config/hypr/scripts/brightness_notification.sh down
sleep 2

echo ""
echo "Testes concluídos! Verifique as notificações na tela."