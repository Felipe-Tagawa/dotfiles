#!/bin/bash
# ==============================================================================
# battery_notification.sh - Gestão dinâmica de taxa de atualização (144Hz/60Hz),
#                           perfis de energia e notificações de bateria crítica.
# ==============================================================================

LOW_BATTERY=20
VERY_LOW_BATTERY=10
CRITICAL_BATTERY=5

# Variáveis para controle de estado
notified_low=false
notified_very_low=false
notified_critical=false
last_status=""

apply_power_profile() {
    local mode="$1"
    if [ "$mode" = "battery" ]; then
        # Alternar monitor eDP-1 para 60Hz
        hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1" &>/dev/null
        # Perfil de economia
        if command -v powerprofilesctl &>/dev/null; then
            powerprofilesctl set power-saver &>/dev/null
        elif command -v tuned-adm &>/dev/null; then
            tuned-adm profile powersave &>/dev/null || tuned-adm profile balanced-battery &>/dev/null
        fi
        notify-send -u normal -a "SwayNC" -i battery-low "Gerenciamento de Energia" "Modo Bateria: display a 60Hz e perfil econômico ativados."
    elif [ "$mode" = "ac" ]; then
        # Restaurar monitor eDP-1 para 144Hz
        hyprctl keyword monitor "eDP-1,1920x1080@144,0x0,1" &>/dev/null
        # Perfil de performance
        if command -v powerprofilesctl &>/dev/null; then
            powerprofilesctl set balanced &>/dev/null || powerprofilesctl set performance &>/dev/null
        elif command -v tuned-adm &>/dev/null; then
            tuned-adm profile throughput-performance &>/dev/null || tuned-adm profile balanced &>/dev/null
        fi
        notify-send -u normal -a "SwayNC" -i battery-charging "Gerenciamento de Energia" "Alimentação AC conectada: display a 144Hz ativado."
    fi
}

while true; do
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

    if [ -n "$BATTERY_STATUS" ]; then
        # Detectar transição de estado da fonte de energia
        if [ "$BATTERY_STATUS" != "$last_status" ] && [ -n "$last_status" ]; then
            if [ "$BATTERY_STATUS" = "Discharging" ]; then
                apply_power_profile "battery"
            elif [ "$BATTERY_STATUS" = "Charging" ] || [ "$BATTERY_STATUS" = "Full" ]; then
                apply_power_profile "ac"
            fi
        fi
        last_status="$BATTERY_STATUS"

        # Notificações de nível crítico de bateria
        if [ "$BATTERY_STATUS" = "Discharging" ]; then
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
        else
            # Reset dos alertas quando conectado à tomada
            notified_low=false
            notified_very_low=false
            notified_critical=false
        fi
    fi

    sleep 5
done
