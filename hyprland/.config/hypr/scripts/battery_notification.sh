#!/bin/bash
# battery_notification.sh - Gestao dinamica de taxa de atualizacao (144Hz/60Hz),
#                           perfis de energia e notificacoes de bateria critica.

LOW_BATTERY=20
VERY_LOW_BATTERY=10
CRITICAL_BATTERY=5

# Variáveis para controle de estado
notified_low=false
notified_very_low=false
notified_critical=false
last_mode=""

apply_power_profile() {
    local mode="$1"
    if [ "$mode" = "battery" ]; then
        # Alternar monitor eDP-1 para 60Hz silenciosamente
        hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1" &>/dev/null
        # Perfil de economia
        if command -v powerprofilesctl &>/dev/null; then
            powerprofilesctl set power-saver &>/dev/null
        elif command -v tuned-adm &>/dev/null; then
            tuned-adm profile powersave &>/dev/null || tuned-adm profile balanced-battery &>/dev/null
        fi
    elif [ "$mode" = "ac" ]; then
        # Restaurar monitor eDP-1 para 144Hz silenciosamente
        hyprctl keyword monitor "eDP-1,1920x1080@144,0x0,1" &>/dev/null
        # Perfil de performance
        if command -v powerprofilesctl &>/dev/null; then
            powerprofilesctl set balanced &>/dev/null || powerprofilesctl set performance &>/dev/null
        elif command -v tuned-adm &>/dev/null; then
            tuned-adm profile throughput-performance &>/dev/null || tuned-adm profile balanced &>/dev/null
        fi
    fi
}

while true; do
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
    AC_ONLINE=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -1)

    if [ "$AC_ONLINE" = "1" ] || [ "$BATTERY_STATUS" = "Charging" ] || [ "$BATTERY_STATUS" = "Full" ]; then
        current_mode="ac"
    else
        current_mode="battery"
    fi

    # Transição de modo de energia (aplica mudanças de taxa de atualização e perfil sem spam de notificação)
    if [ "$current_mode" != "$last_mode" ]; then
        apply_power_profile "$current_mode"
        last_mode="$current_mode"
    fi

    # Notificações de nível crítico de bateria apenas quando estiver fora da tomada
    if [ "$current_mode" = "battery" ] && [ -n "$BATTERY_LEVEL" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ] && [ "$notified_critical" = false ]; then
            notify-send -u critical -a "SwayNC" -i battery-empty "Bateria Crítica" "Bateria em ${BATTERY_LEVEL}%! Conecte o carregador imediatamente."
            notified_critical=true
        elif [ "$BATTERY_LEVEL" -le "$VERY_LOW_BATTERY" ] && [ "$notified_very_low" = false ]; then
            notify-send -u critical -a "SwayNC" -i battery-caution "Bateria Muito Baixa" "Bateria em ${BATTERY_LEVEL}%."
            notified_very_low=true
        elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY" ] && [ "$notified_low" = false ]; then
            notify-send -u normal -a "SwayNC" -i battery-low "Bateria Baixa" "Bateria em ${BATTERY_LEVEL}%."
            notified_low=true
        fi
    elif [ "$current_mode" = "ac" ]; then
        # Reset dos alertas quando conectado à tomada
        notified_low=false
        notified_very_low=false
        notified_critical=false
    fi

    sleep 5
done
