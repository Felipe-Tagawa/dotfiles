#!/bin/bash

# Alterna o HDMI-A-1 entre modo estendido (uso normal com dois monitores)
# e modo espelhado (pra quando for projetar e não quiser ficar olhando
# pra tela preta enquanto o conteúdo aparece só no projetor)
#
# Atualizado para o Hyprland 0.55+ (config em Lua): a partir dessa versão
# "hyprctl keyword monitor ..." (sintaxe antiga do hyprlang) não é mais
# reconhecido -> retorna "unknown request". Em runtime agora se usa
# "hyprctl eval" para chamar a mesma API Lua (hl.monitor) do config.
#
# IMPORTANTE: hl.monitor() usa a regra JÁ EXISTENTE daquele output como
# base — qualquer campo omitido mantém o valor anterior (não reseta pro
# padrão). Por isso, pra tirar o espelhamento, é preciso passar
# mirror = "" (string vazia) explicitamente; só omitir o campo "mirror"
# NÃO remove o mirror antigo.

STATE_FILE="/tmp/hypr-projetor-state"

if [ ! -f "$STATE_FILE" ]; then
    echo "estendido" > "$STATE_FILE"
fi

MODO_ATUAL=$(cat "$STATE_FILE")

if [ "$MODO_ATUAL" = "estendido" ]; then
    # Muda pra espelhado: HDMI passa a reproduzir exatamente o eDP-1
    hyprctl eval 'hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1, mirror = "eDP-1" })'
    echo "espelhado" > "$STATE_FILE"
    notify-send "Projeção" "Modo espelhado ativado" 2>/dev/null
else
    # Volta pro estendido, igual sua config original
    # mirror = "" é obrigatório aqui pra realmente limpar o espelhamento antigo
    hyprctl eval 'hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "auto", scale = 1, mirror = "" })'
    echo "estendido" > "$STATE_FILE"
    notify-send "Projeção" "Modo estendido ativado" 2>/dev/null
fi
