#!/usr/bin/env bash
# Hyprland Global Theme Switcher with Circular Growth Transition
# Switches: Wallpaper (swww), Hyprland Borders, Waybar, Kitty, Rofi, GTK, Neovim
# Supports: Presets (Catppuccin, Gruvbox, etc.) & Dynamic Material You (Matugen)

STATE_FILE="$HOME/.config/hypr/.current_theme_name"
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"
[ ! -d "$WALLPAPERS_DIR" ] && WALLPAPERS_DIR="$HOME/dotfiles/Wallpaper/Pictures/Wallpapers"

# Dynamic Material You Theme from Wallpaper (Matugen)
apply_matugen() {
    local wallpaper="$1"

    # Se não passou imagem, abre a galeria visual em grade do Rofi
    if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
        local picker_script="$HOME/.config/hypr/scripts/select-wallpaper.sh"
        if [ -x "$picker_script" ]; then
            wallpaper=$("$picker_script")
        else
            wallpaper=$(python3 "$HOME/dotfiles/hyprland/.config/hypr/scripts/select-wallpaper.sh")
        fi
        [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ] && exit 0
    fi

    [ ! -f "$wallpaper" ] && exit 1

    # 1. Coordenadas do cursor para expansão do círculo
    local cursor_pos
    cursor_pos=$(hyprctl cursorpos 2>&1 | tr -d ' ')
    if [[ ! "$cursor_pos" =~ ^[0-9]+,[0-9]+$ ]]; then
        cursor_pos="center"
    fi

    # 2. Iniciar swww se necessário
    if ! pgrep -x "swww-daemon" > /dev/null; then
        swww-daemon &
        sleep 0.1
    fi

    # 3. Transição circular rápida e fluida com filtro Mitchell
    swww img "$wallpaper" \
        --transition-type grow \
        --transition-pos "$cursor_pos" \
        --invert-y \
        --transition-step 90 \
        --transition-fps 60 \
        --filter Mitchell \
        --transition-duration 0.5 &

    # 4. Extrair cores e renderizar templates com Matugen
    if command -v matugen &>/dev/null; then
        matugen --config "$HOME/.config/matugen/config.toml" image --source-color-index 0 "$wallpaper" >/dev/null 2>&1
    fi

    # 5. Aplicar novas cores de borda e sombra no Hyprland ao vivo via Lua
    if [ -f "$HOME/.config/hypr/current_theme.lua" ]; then
        local hl_active_1 hl_active_2 hl_active_3 hl_inactive hl_shadow hl_shadow_inactive
        eval $(awk -F'"' '/active_1|active_2|active_3|inactive|shadow/ {gsub(/[[:space:]]/, ""); print "hl_" $1 "\"" $2 "\""}' "$HOME/.config/hypr/current_theme.lua" 2>/dev/null)

        [ -z "$hl_shadow" ] && hl_shadow="0x88${hl_active_1#0xff}"
        [ -z "$hl_shadow_inactive" ] && hl_shadow_inactive="0x44000000"
        [ -z "$hl_active_3" ] && hl_active_3="$hl_active_1"

        if [ -n "$hl_active_1" ] && [ -n "$hl_active_2" ]; then
            hyprctl eval "hl.config({ general = { col = { active_border = { colors = { '${hl_active_1}', '${hl_active_2}', '${hl_active_3}' }, angle = 45 }, inactive_border = '${hl_inactive}' } }, decoration = { shadow = { enabled = true, range = 16, render_power = 3, color = '${hl_shadow}', color_inactive = '${hl_shadow_inactive}' } } })" >/dev/null 2>&1 &
        fi
    fi

    # 6. Atualizar Waybar para o tema MaterialYou com cores dinâmicas (recarga instantânea se já estiver no MaterialYou)
    local waybar_theme="$HOME/.config/waybar/MaterialYou"
    if [ -d "$waybar_theme" ]; then
        local current_waybar
        current_waybar=$(readlink -f "$HOME/.config/waybar/current" 2>/dev/null)
        if [ "$current_waybar" = "$waybar_theme" ] && pgrep -x waybar >/dev/null; then
            pkill -SIGUSR2 waybar 2>/dev/null || true
        else
            ln -sfn "$waybar_theme" "$HOME/.config/waybar/current"
            "$HOME/.config/waybar/start.sh" >/dev/null 2>&1 &
        fi
    fi

    # 7. Atualizar Kitty, SwayNC e Spotify de forma assíncrona
    pkill -SIGUSR1 kitty 2>/dev/null || true
    swaync-client -rs 2>/dev/null &
    (spicetify apply >/dev/null 2>&1 &)

    # 8. Salvar estado e notificar
    echo "material-you" > "$STATE_FILE"
    echo "$wallpaper" > "$HOME/.config/hypr/.current_wallpaper"
    notify-send -t 1500 -a "Material You" "Tema Dinâmico Gerado" "$(basename "$wallpaper")" >/dev/null 2>&1 &
}

# Preset Themes Application Function
apply_theme() {
    local theme="$1"
    local wallpaper=""
    local waybar_theme=""
    local kitty_theme=""
    local rofi_color=""
    local hl_active_1=""
    local hl_active_2=""
    local hl_active_3=""
    local hl_inactive=""
    local hl_shadow=""
    local hl_shadow_inactive=""
    local gtk_theme=""
    local icon_theme=""
    local nvim_theme=""
    local display_name=""

    case "$theme" in
        "catppuccin")
            display_name="Catppuccin Mocha"
            wallpaper="$WALLPAPERS_DIR/horse.jpg"
            [ ! -f "$wallpaper" ] && wallpaper="$WALLPAPERS_DIR/vagabond.png"
            waybar_theme="$HOME/.config/waybar/CatMat"
            kitty_theme="$HOME/.config/kitty/catppuccin-mocha.conf"
            rofi_color="$HOME/.config/rofi/colors/catppuccin.rasi"
            hl_active_1="0xffcba6f7"
            hl_active_2="0xffb4befe"
            hl_active_3="0xfff5c2e7"
            hl_inactive="0xff313244"
            hl_shadow="0x88cba6f7"
            hl_shadow_inactive="0x4411111b"
            gtk_theme="catppuccin-mocha-mauve-standard+default"
            icon_theme="Papirus-Dark"
            nvim_theme="catppuccin-mocha"
            ;;

        "gruvbox")
            display_name="Gruvbox Retro"
            wallpaper="$WALLPAPERS_DIR/musashi.png"
            waybar_theme="$HOME/.config/waybar/minim"
            kitty_theme="$HOME/.config/kitty/themes/gruvboxd-theme.conf"
            rofi_color="$HOME/.config/rofi/colors/gruvbox.rasi"
            hl_active_1="0xffd79921"
            hl_active_2="0xfffe8019"
            hl_active_3="0xffebdbb2"
            hl_inactive="0xff3c3836"
            hl_shadow="0x88d79921"
            hl_shadow_inactive="0x441d2021"
            gtk_theme="Gruvbox-BL-MB-Dark"
            icon_theme="Gruvbox-Light"
            nvim_theme="gruvbox"
            ;;

        "rose-pine")
            display_name="Rose Pine Moon"
            wallpaper="$WALLPAPERS_DIR/lady_maria.png"
            [ ! -f "$wallpaper" ] && wallpaper="$WALLPAPERS_DIR/rose_pine.webp"
            waybar_theme="$HOME/.config/waybar/FullMacchiato"
            kitty_theme="$HOME/.config/kitty/themes/rose-pine-moon.conf"
            rofi_color="$HOME/.config/rofi/colors/rosepine.rasi"
            hl_active_1="0xffea9a97"
            hl_active_2="0xffc4a7e7"
            hl_active_3="0xffebbcba"
            hl_inactive="0xff26233a"
            hl_shadow="0x88ea9a97"
            hl_shadow_inactive="0x44191724"
            gtk_theme="rose-pine-moon-gtk"
            icon_theme="Papirus-Dark"
            nvim_theme="rose-pine"
            ;;

        "tokyo-night")
            display_name="Tokyo Night / Cyber"
            wallpaper="$WALLPAPERS_DIR/ff13.jpg"
            waybar_theme="$HOME/.config/waybar/DigitalVoid"
            kitty_theme="$HOME/.config/kitty/themes/tokyo-night.conf"
            rofi_color="$HOME/.config/rofi/colors/tokyonight.rasi"
            hl_active_1="0xff7aa2f7"
            hl_active_2="0xffbb9af7"
            hl_active_3="0xff7dcfff"
            hl_inactive="0xff1a1b26"
            hl_shadow="0x887aa2f7"
            hl_shadow_inactive="0x4416161e"
            gtk_theme="Breeze"
            icon_theme="breeze-dark"
            nvim_theme="tokyonight"
            ;;

        "zen")
            display_name="Minimal Zen / Climber"
            wallpaper="$WALLPAPERS_DIR/theClimber.png"
            waybar_theme="$HOME/.config/waybar/Zen"
            kitty_theme="$HOME/.config/kitty/themes/zen.conf"
            rofi_color="$HOME/.config/rofi/colors/nord.rasi"
            hl_active_1="0xff74c7ec"
            hl_active_2="0xff89dceb"
            hl_active_3="0xffcdd6f4"
            hl_inactive="0xff1e1e2e"
            hl_shadow="0x8874c7ec"
            hl_shadow_inactive="0x4411111b"
            gtk_theme="Breeze"
            icon_theme="breeze-dark"
            nvim_theme="desert"
            ;;

        "hunter")
            display_name="Dark Hunter / Bloodborne"
            wallpaper="$WALLPAPERS_DIR/hunter.png"
            waybar_theme="$HOME/.config/waybar/Pills"
            kitty_theme="$HOME/.config/kitty/themes/rose-pine-moon.conf"
            rofi_color="$HOME/.config/rofi/colors/dracula.rasi"
            hl_active_1="0xffe06c75"
            hl_active_2="0xffbe5046"
            hl_active_3="0xffe5c07b"
            hl_inactive="0xff1e1e2e"
            hl_shadow="0x88e06c75"
            hl_shadow_inactive="0x44000000"
            gtk_theme="Dracula"
            icon_theme="Papirus-Dark"
            nvim_theme="desert"
            ;;

        *)
            echo "Tema desconhecido: $theme"
            exit 1
            ;;
    esac

    # 1. Coordenadas do cursor para expansão do círculo
    local cursor_pos
    cursor_pos=$(hyprctl cursorpos 2>&1 | tr -d ' ')
    if [[ ! "$cursor_pos" =~ ^[0-9]+,[0-9]+$ ]]; then
        cursor_pos="center"
    fi

    # 2. Inicializar swww se não estiver rodando
    if ! pgrep -x "swww-daemon" > /dev/null; then
        swww-daemon &
        sleep 0.1
    fi

    # 3. Transição circular rápida e fluida
    if [ -f "$wallpaper" ]; then
        swww img "$wallpaper" \
            --transition-type grow \
            --transition-pos "$cursor_pos" \
            --invert-y \
            --transition-step 90 \
            --transition-fps 60 \
            --filter Mitchell \
            --transition-duration 0.5 &
    fi

    # 4. Atualizar bordas e sombras do Hyprland dinamicamente via Lua
    hyprctl eval "hl.config({ general = { col = { active_border = { colors = { '${hl_active_1}', '${hl_active_2}', '${hl_active_3}' }, angle = 45 }, inactive_border = '${hl_inactive}' } }, decoration = { shadow = { enabled = true, range = 16, render_power = 3, color = '${hl_shadow}', color_inactive = '${hl_shadow_inactive}' } } })" >/dev/null 2>&1 &

    # Persistir cores para novas sessões do Hyprland
    cat <<EOF > "$HOME/.config/hypr/current_theme.lua"
return {
    active_1 = "${hl_active_1}",
    active_2 = "${hl_active_2}",
    active_3 = "${hl_active_3}",
    inactive = "${hl_inactive}",
    shadow = "${hl_shadow}",
    shadow_inactive = "${hl_shadow_inactive}",
    theme_name = "${theme}",
}
EOF

    # 5. Atualizar Waybar
    if [ -d "$waybar_theme" ]; then
        ln -sfn "$waybar_theme" "$HOME/.config/waybar/current"
        "$HOME/.config/waybar/start.sh" >/dev/null 2>&1 &
    fi

    # 6. Atualizar Kitty instantaneamente
    if [ -f "$kitty_theme" ]; then
        cp "$kitty_theme" "$HOME/.config/kitty/current-theme.conf"
        pkill -SIGUSR1 kitty 2>/dev/null || true
    fi

    # 7. Atualizar Rofi colors
    if [ -f "$rofi_color" ]; then
        ln -sfn "$rofi_color" "$HOME/.config/rofi/colors/current.rasi"
    fi

    # 8. Atualizar GTK e Ícones
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null || true
    fi

    # 9. Atualizar Neovim, SwayNC e Spotify (assíncrono)
    mkdir -p "$HOME/.config/nvim"
    echo "$nvim_theme" > "$HOME/.config/nvim/current_theme.txt"
    swaync-client -rs 2>/dev/null &
    (spicetify apply >/dev/null 2>&1 &)

    # 10. Salvar estado atual e notificar
    echo "$theme" > "$STATE_FILE"
    echo "$wallpaper" > "$HOME/.config/hypr/.current_wallpaper"
    notify-send -t 1500 -a "Tema" "Tema Ativado" "$display_name" >/dev/null 2>&1 &
}

# Modos de Execucao: menu, next, matugen/wall ou nome do tema
ACTION="${1:-menu}"

THEMES_LIST=("catppuccin" "gruvbox" "rose-pine" "tokyo-night" "zen" "hunter")

case "$ACTION" in
    "restore"|"init")
        CURRENT_WALL=$(cat "$HOME/.config/hypr/.current_wallpaper" 2>/dev/null)
        
        # 1. Iniciar swww-daemon se necessário
        if ! pgrep -x "swww-daemon" > /dev/null; then
            swww-daemon &
            for _ in {1..30}; do
                swww query >/dev/null 2>&1 && break
                sleep 0.1
            done
        fi

        # 2. Restaurar wallpaper salvo imediatamente
        if [ -n "$CURRENT_WALL" ] && [ -f "$CURRENT_WALL" ]; then
            swww img "$CURRENT_WALL" --transition-type none 2>/dev/null
        else
            DEFAULT_WALL=$(find "$WALLPAPERS_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null | head -n1)
            if [ -n "$DEFAULT_WALL" ]; then
                echo "$DEFAULT_WALL" > "$HOME/.config/hypr/.current_wallpaper"
                swww img "$DEFAULT_WALL" --transition-type none 2>/dev/null
            fi
        fi
        exit 0
        ;;

    "-h"|"--help"|"help")
        echo "Uso: theme-switcher.sh [menu|restore|next|wall|catppuccin|gruvbox|rose-pine|tokyo-night|zen|hunter]"
        echo "  menu           Abre menu no Rofi (padrão)"
        echo "  restore        Restaura o último wallpaper salvo no boot"
        echo "  wall [img]     Gera tema dinâmico (Material You) a partir do wallpaper"
        echo "  next           Avança para o próximo preset no ciclo"
        echo "  <preset>       Aplica um preset específico"
        exit 0
        ;;

    "matugen"|"wall"|"wallpaper"|"dynamic")
        apply_matugen "$2"
        ;;

    "next")
        CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "catppuccin")
        NEXT="catppuccin"
        for i in "${!THEMES_LIST[@]}"; do
            if [ "${THEMES_LIST[$i]}" = "$CURRENT" ]; then
                NEXT_INDEX=$(( (i + 1) % ${#THEMES_LIST[@]} ))
                NEXT="${THEMES_LIST[$NEXT_INDEX]}"
                break
            fi
        done
        apply_theme "$NEXT"
        ;;

    "menu")
        MENU_OPTIONS="1. Material You (Escolher Wallpaper)\n2. Catppuccin Mocha\n3. Gruvbox Retro\n4. Rose Pine Moon\n5. Tokyo Night / Cyber\n6. Minimal Zen (Climber)\n7. Dark Hunter (Bloodborne)\n8. Proximo Tema (Ciclo)"
        
        SELECTED=$(echo -e "$MENU_OPTIONS" | rofi -dmenu -i -p "Tema" -theme "$HOME/.config/rofi/clipboard.rasi")
        
        case "$SELECTED" in
            *"Material You"*)
                apply_matugen ""
                ;;
            *"Catppuccin"*)
                apply_theme "catppuccin"
                ;;
            *"Gruvbox"*)
                apply_theme "gruvbox"
                ;;
            *"Rose Pine"*)
                apply_theme "rose-pine"
                ;;
            *"Tokyo Night"*)
                apply_theme "tokyo-night"
                ;;
            *"Minimal Zen"*)
                apply_theme "zen"
                ;;
            *"Dark Hunter"*)
                apply_theme "hunter"
                ;;
            *"Proximo"*|*"Próximo"*)
                "$0" next
                ;;
        esac
        ;;

    *)
        apply_theme "$ACTION"
        ;;
esac
