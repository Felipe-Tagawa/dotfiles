#!/bin/bash

# Notificação de atualizações do sistema
# Uso: adicionar ao crontab para execução diária

if command -v checkupdates &> /dev/null; then
    UPDATES=$(checkupdates 2>/dev/null | wc -l)

    if [ "$UPDATES" -gt 0 ]; then
        if [ "$UPDATES" -eq 1 ]; then
            notify-send -u normal "Atualização Disponível" "Há 1 pacote disponível para atualização."
        else
            notify-send -u normal "Atualizações Disponíveis" "Há $UPDATES pacotes disponíveis para atualização."
        fi
    fi
elif command -v apt-get &> /dev/null; then
    UPDATES=$(apt-get -s upgrade 2>/dev/null | grep -P '^\d+ upgraded' | awk '{print $1}')

    if [ "$UPDATES" -gt 0 ]; then
        if [ "$UPDATES" -eq 1 ]; then
            notify-send -u normal "Atualização Disponível" "Há 1 pacote disponível para atualização."
        else
            notify-send -u normal "Atualizações Disponíveis" "Há $UPDATES pacotes disponíveis para atualização."
        fi
    fi
fi