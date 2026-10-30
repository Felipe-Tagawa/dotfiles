#!/usr/bin/env bash
# =============================================================================
# Jarvis Spotlight Menu Launcher
# =============================================================================

THEME="$HOME/.config/jarvis/ui/jarvis.rasi"
ROFI_ARGS=(-dmenu -i -p "Jarvis:")

if [ -f "$THEME" ]; then
    ROFI_ARGS+=(-theme "$THEME")
fi

OPTIONS="Auto-Fix (Analisar e corrigir erro do clipboard)
Refatorar codigo da area de transferencia
Gerar testes unitarios
Explicar codigo ou erro
Pair-Programmer (Abrir sessao interativa no projeto)
Alternar motor (agy / ollama)"

CHOICE=$(echo -e "$OPTIONS" | rofi "${ROFI_ARGS[@]}")

# Se cancelou (ESC)
if [ -z "$CHOICE" ]; then
    exit 0
fi

JARVIS="$HOME/.config/jarvis/bin/jarvis"

case "$CHOICE" in
    *"Auto-Fix"*)
        "$JARVIS" --popup autofix
        ;;
    *"Refatorar"*)
        "$JARVIS" --popup refactor
        ;;
    *"Gerar testes"*)
        "$JARVIS" --popup test
        ;;
    *"Explicar"*)
        "$JARVIS" --popup explain
        ;;
    *"Pair-Programmer"*)
        "$JARVIS" pair
        ;;
    *"Alternar motor"*)
        CONFIG="$HOME/.config/jarvis/config.json"
        CURRENT=$(grep -o '"default_engine": *"[^"]*"' "$CONFIG" | cut -d'"' -f4)
        if [ "$CURRENT" = "agy" ]; then
            sed -i 's/"default_engine": *"agy"/"default_engine": "ollama"/' "$CONFIG"
            notify-send -a "Jarvis" -i dialog-information "Motor de IA" "Alternado para: Ollama (Llama 3.1 Local)"
        else
            sed -i 's/"default_engine": *"ollama"/"default_engine": "agy"/' "$CONFIG"
            notify-send -a "Jarvis" -i dialog-information "Motor de IA" "Alternado para: agy (Google DeepMind)"
        fi
        ;;
    *)
        # Qualquer pergunta livre digitada pelo usuario
        "$JARVIS" --popup prompt "$CHOICE"
        ;;
esac
