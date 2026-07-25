#!/bin/bash

# Script para habilitar os serviços de notificação do systemd

echo "Habilitando serviços de notificação..."

# Habilitar e iniciar o serviço de bateria
systemctl --user enable battery-notification.service
systemctl --user start battery-notification.service

# Habilitar e iniciar o serviço de disco
systemctl --user enable disk-notification.service
systemctl --user start disk-notification.service

echo "Serviços de notificação habilitados e iniciados!"