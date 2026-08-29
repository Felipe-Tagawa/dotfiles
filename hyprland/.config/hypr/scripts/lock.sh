#!/usr/bin/env bash

# Evita que múltiplas instâncias do gtklock sejam lançadas ao mesmo tempo
if pidof gtklock > /dev/null; then
    exit 0
fi

# Caminho da imagem temporária
IMAGE=/tmp/screen_lock.png

# 1. Tira print da tela com grim.
if grim $IMAGE; then
    # 2. Borra a imagem se o print funcionou.
    convert $IMAGE -blur 0x8 $IMAGE
    
    # 3. Executa o gtklock com a imagem borrada.
    gtklock -b $IMAGE
else
    echo "Erro: Não foi possível tirar o print da tela com 'grim'."
    gtklock
fi

# 4. Apaga a imagem temporária ao desbloquear.
rm -f $IMAGE
