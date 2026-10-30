#!/usr/bin/env bash
# =============================================================================
# Clipboard History Selector (Rofi + Cliphist + Image Previews)
# =============================================================================

CACHE_DIR="/tmp/cliphist-thumbs"
mkdir -p "$CACHE_DIR"

THEME="$HOME/.config/rofi/clipboard.rasi"
ROFI_ARGS=(-dmenu -i -p "📋")

if [ -f "$THEME" ]; then
    ROFI_ARGS+=(-theme "$THEME")
fi

# Gera a lista para o Rofi com miniaturas de imagens e ícones de texto
generate_list() {
    cliphist list | while IFS=$'\t' read -r id content; do
        if [[ "$content" == *"[[ binary data"* ]]; then
            thumb="$CACHE_DIR/${id}.png"
            if [ ! -f "$thumb" ]; then
                echo -e "$id\t$content" | cliphist decode > "$thumb" 2>/dev/null
            fi
            echo -en "$id\t$content\0icon\x1f$thumb\n"
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
