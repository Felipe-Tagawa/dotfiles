#!/usr/bin/env bash

# Inicia o daemon do cliphist para texto e imagem em background se ainda não estiverem rodando
if ! pgrep -f "wl-paste --type text --watch cliphist store" > /dev/null; then
    wl-paste --type text --watch cliphist store &
fi

if ! pgrep -f "wl-paste --type image --watch cliphist store" > /dev/null; then
    wl-paste --type image --watch cliphist store &
fi
