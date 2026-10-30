#!/bin/bash
# ==============================================================================
# dotfiles-check.sh - Monitor e notificador de alterações pendentes nos dotfiles
# ==============================================================================

DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
    exit 0
fi

# Checar se há alterações locais modificadas ou novos arquivos
CHANGES=$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null | wc -l)

if [ "$CHANGES" -gt 0 ]; then
    notify-send -u low -a "SwayNC" -i git \
        "Dotfiles" \
        "Você tem $CHANGES alteração(ões) pendente(s) no seu repositório ~/dotfiles."
fi
