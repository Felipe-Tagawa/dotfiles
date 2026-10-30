# =============================================================================
# 20-wayland.sh: Wayland, Hyprland & Input Module Configurations
# =============================================================================

# Wayland Session variables
export XDG_SESSION_TYPE=wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# Cedilla support for US-International layout is handled cleanly by ~/.XCompose
# (GTK_IM_MODULE / QT_IM_MODULE are deprecated in Wayland and break GTK4/Chromium)

# X11 fallback keyboard helpers (if running under XWayland/X11)
if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$DISPLAY" ]; then
    setxkbmap -layout us -variant intl 2>/dev/null
fi

alias teclado-br='setxkbmap -model abnt2 -layout br -variant abnt2 2>/dev/null'
alias teclado-us='setxkbmap -layout us 2>/dev/null'
