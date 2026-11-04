#!/usr/bin/env bash
# Clipboard History Selector & Cleaner (Rofi + Cliphist + Image Previews)
# Otimizado para abertura instantânea (cache persistente, limite recente e decodificação não-bloqueante)

CACHE_DIR="$HOME/.cache/cliphist/thumbs"
MAX_ITEMS=80

if [ "$1" = "clear" ] || [ "$1" = "wipe" ]; then
    cliphist wipe
    rm -rf "$CACHE_DIR"/* 2>/dev/null
    notify-send -i edit-clear "Clipboard" "Histórico limpo"
    exit 0
fi

mkdir -p "$CACHE_DIR"

THEME="$HOME/.config/rofi/clipboard.rasi"
ROFI_ARGS=(-dmenu -i -p "Clipboard")

if [ -f "$THEME" ]; then
    ROFI_ARGS+=(-theme "$THEME")
fi

# Gera a lista para o Rofi de forma rápida
generate_list() {
    cliphist list | head -n "$MAX_ITEMS" | while IFS=$'\t' read -r id content; do
        if [[ "$content" == *"[[ binary data"* ]]; then
            thumb="$CACHE_DIR/${id}.png"
            if [ -f "$thumb" ]; then
                echo -en "$id\t$content\0icon\x1f$thumb\n"
            else
                # Decodifica em segundo plano para não bloquear a abertura do Rofi
                (echo -e "$id\t$content" | cliphist decode > "$thumb" 2>/dev/null) &
                echo -en "$id\t$content\0icon\x1fimage-x-generic\n"
            fi
        else
            echo -en "$id\t$content\0icon\x1fedit-paste\n"
        fi
    done
}

selected=$(generate_list | rofi "${ROFI_ARGS[@]}" -display-columns 2)

# Se o usuário escolheu algo (não cancelou / ESC)
if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
    notify-send -t 1500 -a "Clipboard" -i edit-paste "Área de Transferência" "Item copiado para o clipboard"
fi
