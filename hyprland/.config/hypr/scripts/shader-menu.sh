#!/usr/bin/env bash
# =============================================================================
# Hyprland Shader Selector & Toggle (Hyprshade Alternative)
# Compatible with Hyprland 0.56+ Lua API and Legacy Keywords
# =============================================================================

SHADERS_DIR="$HOME/.config/hypr/shaders"
STATE_FILE="/tmp/hypr_active_shader"
LAST_SHADER_FILE="/tmp/hypr_last_shader"

# Garante que o HYPRLAND_INSTANCE_SIGNATURE seja detectado se não estiver no ambiente
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    HYPR_INST=$(ls -t /run/user/$(id -u)/hypr 2>/dev/null | head -n1)
    if [ -n "$HYPR_INST" ]; then
        export HYPRLAND_INSTANCE_SIGNATURE="$HYPR_INST"
    fi
fi

apply_shader() {
    local shader_name="$1"
    local shader_path="$2"
    local desc="$3"

    if [ -z "$shader_path" ] || [ "$shader_name" = "none" ]; then
        # Desativa tanto na API Lua quanto no keyword
        hyprctl eval "hl.config({ decoration = { screen_shader = '' } })" >/dev/null 2>&1
        hyprctl keyword decoration:screen_shader "" >/dev/null 2>&1
        rm -f "$STATE_FILE"
        notify-send -a "Hyprland Shader" -i video-display "Shader Desativado" "Exibição padrão restaurada"
    else
        # Ativa tanto na API Lua quanto no keyword
        hyprctl eval "hl.config({ decoration = { screen_shader = '${shader_path}' } })" >/dev/null 2>&1
        hyprctl keyword decoration:screen_shader "$shader_path" >/dev/null 2>&1
        echo "$shader_name" > "$STATE_FILE"
        echo "$shader_path" > "$LAST_SHADER_FILE"
        notify-send -a "Hyprland Shader" -i video-display "Shader Ativado" "$desc"
    fi
}

toggle_shader() {
    if [ -f "$STATE_FILE" ]; then
        apply_shader "none" "" ""
    else
        if [ -f "$LAST_SHADER_FILE" ]; then
            last_path=$(cat "$LAST_SHADER_FILE")
            last_name=$(basename "$last_path" .glsl)
            apply_shader "$last_name" "$last_path" "Restaurado shader anterior: $last_name"
        else
            apply_shader "blue-light-filter" "$SHADERS_DIR/blue-light-filter.glsl" "Luz Noturna (Filtro Azul)"
        fi
    fi
}

if [ "$1" = "toggle" ]; then
    toggle_shader
    exit 0
fi

# Se um nome foi passado diretamente
if [ -n "$1" ]; then
    case "$1" in
        off|none|disable)
            apply_shader "none" "" ""
            exit 0
            ;;
        vibrance)
            apply_shader "vibrance" "$SHADERS_DIR/vibrance.glsl" "Vibrance (Cores Vivas & Contraste)"
            exit 0
            ;;
        night|bluelight|blue-light)
            apply_shader "blue-light-filter" "$SHADERS_DIR/blue-light-filter.glsl" "Luz Noturna (Descanso Visual)"
            exit 0
            ;;
        zen|gray|grayscale)
            apply_shader "grayscale" "$SHADERS_DIR/grayscale.glsl" "Zen Mode (Monocromático E-Ink)"
            exit 0
            ;;
        crt)
            apply_shader "crt" "$SHADERS_DIR/crt.glsl" "Retrô Arcade CRT (Scanlines)"
            exit 0
            ;;
        invert)
            apply_shader "invert" "$SHADERS_DIR/invert.glsl" "Inversão de Cores"
            exit 0
            ;;
    esac
fi

# Menu Interativo via Rofi
OPTIONS="🌟 Nenhum (Desativar Shader)\n🌈 Vibrance (Cores Vivas)\n🌙 Luz Noturna (Filtro Azul)\n🖤 Zen Mode (Monocromático)\n🕹️ Retrô CRT (Scanlines)\n🌓 Inverter Cores"

ROFI_THEME="$HOME/.config/rofi/colors/current.rasi"
ROFI_ARGS=(-dmenu -i -p "󰔎 Shaders")

if [ -f "$ROFI_THEME" ]; then
    ROFI_ARGS+=(-theme "$ROFI_THEME")
fi

CHOICE=$(echo -e "$OPTIONS" | rofi "${ROFI_ARGS[@]}")

case "$CHOICE" in
    *"Nenhum"*)
        apply_shader "none" "" ""
        ;;
    *"Vibrance"*)
        apply_shader "vibrance" "$SHADERS_DIR/vibrance.glsl" "Vibrance (Cores Vivas & Contraste)"
        ;;
    *"Luz Noturna"*)
        apply_shader "blue-light-filter" "$SHADERS_DIR/blue-light-filter.glsl" "Luz Noturna (Descanso Visual)"
        ;;
    *"Zen Mode"*)
        apply_shader "grayscale" "$SHADERS_DIR/grayscale.glsl" "Zen Mode (Monocromático E-Ink)"
        ;;
    *"Retrô CRT"*)
        apply_shader "crt" "$SHADERS_DIR/crt.glsl" "Retrô Arcade CRT (Scanlines)"
        ;;
    *"Inverter"*)
        apply_shader "invert" "$SHADERS_DIR/invert.glsl" "Inversão de Cores"
        ;;
esac
