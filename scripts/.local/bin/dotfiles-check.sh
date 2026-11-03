#!/bin/bash
# dotfiles-check.sh - Monitor e notificador de alteracoes pendentes nos dotfiles

DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
    exit 0
fi

# Checar se ha alteracoes locais modificadas ou novos arquivos
CHANGES=$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null | wc -l)

if [ "$CHANGES" -gt 0 ]; then
    notify-send -u low -a "SwayNC" -i git \
        "Dotfiles" \
        "Voce tem $CHANGES alteracao(oes) pendente(s) no seu repositorio ~/dotfiles."
fi
