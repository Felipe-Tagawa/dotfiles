#!/usr/bin/env bash
# Rofi Beats - Lo-Fi & Synthwave Radio Player

PID_FILE="/tmp/rofi-beats.pid"
CURRENT_STATION_FILE="/tmp/rofi-beats.station"

THEME="$HOME/.config/rofi/colors/current.rasi"
ROFI_ARGS=(-dmenu -i -p "Rofi Beats")

if [ -f "$THEME" ]; then
    ROFI_ARGS+=(-theme "$THEME")
fi

stop_radio() {
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE" "$CURRENT_STATION_FILE"
        notify-send -a "Rofi Beats" -i media-playback-stop "Rádio Parada" "Reprodução encerrada"
    fi
}

play_radio() {
    local station="$1"
    local url="$2"

    stop_radio
    sleep 0.2

    # Inicia o mpv em background com título amigável para o MPRIS/Waybar
    mpv --no-video \
        --msg-level=all=no \
        --title="Rofi Beats: $station" \
        "$url" >/dev/null 2>&1 &

    echo $! > "$PID_FILE"
    echo "$station" > "$CURRENT_STATION_FILE"

    notify-send -a "Rofi Beats" -i media-playback-start "Tocando Agora" "$station"
}

# Se chamado com argumento direto
if [ "$1" = "toggle" ] || [ "$1" = "stop" ]; then
    if [ -f "$PID_FILE" ]; then
        stop_radio
    else
        play_radio "Lofi Girl (Hip Hop)" "https://play.streamafrica.net/lofiradio"
    fi
    exit 0
fi

# Lista de opcoes
OPTIONS="Lofi Girl (Beats to Relax/Study)\nNightride FM (Synthwave / Retrowave)\nChillsynth FM (Relax / Ambient Synth)\nDarksynth FM (Cyberpunk / Heavy Synth)\nCoffee Shop Jazz (Piano & Cafe Beats)\nLofi Sleep & Ambient Rain\nParar Reproducao"

CHOICE=$(echo -e "$OPTIONS" | rofi "${ROFI_ARGS[@]}")

case "$CHOICE" in
    *"Lofi Girl"*)
        play_radio "Lofi Girl (Relax/Study)" "https://play.streamafrica.net/lofiradio"
        ;;
    *"Nightride FM"*)
        play_radio "Nightride FM (Synthwave)" "https://stream.nightride.fm/nightride.mp3"
        ;;
    *"Chillsynth"*)
        play_radio "Chillsynth FM (Chillwave)" "https://stream.nightride.fm/chillsynth.mp3"
        ;;
    *"Darksynth"*)
        play_radio "Darksynth FM (Cyberpunk)" "https://stream.nightride.fm/darksynth.mp3"
        ;;
    *"Coffee Shop Jazz"*)
        play_radio "Coffee Shop Jazz" "https://stream.zeno.fm/f3wvbbqmdg8uv"
        ;;
    *"Sleep & Ambient"*)
        play_radio "Lofi Ambient Rain" "https://stream.zeno.fm/0r0xa792kwzuv"
        ;;
    *"Parar"*)
        stop_radio
        ;;
esac
