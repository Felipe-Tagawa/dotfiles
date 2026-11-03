#!/bin/bash
# fedora-maintenance.sh - Rotina automatizada de manutencao e limpeza no Fedora

export PATH="$HOME/.local/bin:$PATH"

SILENT=false
if [ "$1" = "--silent" ] || [ "$1" = "-s" ]; then
    SILENT=true
fi

log_msg() {
    if [ "$SILENT" = false ]; then
        echo "$1"
    fi
}

log_msg "Iniciando manutencao preventiva do Fedora..."

# 1. Limpeza de runtimes e dependencias orfas do Flatpak
if command -v flatpak &>/dev/null; then
    log_msg "Removendo dependencias e runtimes Flatpak nao utilizados..."
    flatpak uninstall --unused -y &>/dev/null || true
fi

# 2. Limpeza de pacotes em cache do gerenciador DNF5 / DNF
if command -v dnf5 &>/dev/null; then
    log_msg "Limpando pacotes temporarios do DNF5..."
    dnf5 clean packages -y &>/dev/null || true
elif command -v dnf &>/dev/null; then
    log_msg "Limpando pacotes temporarios do DNF..."
    dnf clean packages -y &>/dev/null || true
fi

# 3. Limpeza de caches corrompidos de ServiceWorker do Microsoft Teams no Firefox
if [ -x "$HOME/.local/bin/abrir_teams.sh" ]; then
    log_msg "Executando limpeza de cache do Teams no Firefox..."
    "$HOME/.local/bin/abrir_teams.sh" --only-clean &>/dev/null || true
fi

# 4. Checagem de atualizacoes pendentes do sistema
UPDATES=0
if command -v dnf5 &>/dev/null; then
    UPDATES=$(dnf5 check-upgrade -q 2>/dev/null | grep -E '^[a-zA-Z0-9]' | wc -l)
elif command -v dnf &>/dev/null; then
    UPDATES=$(dnf check-update -q 2>/dev/null | grep -E '^[a-zA-Z0-9]' | wc -l)
fi

if [ -n "$UPDATES" ] && [ "$UPDATES" -gt 0 ]; then
    notify-send -u normal -a "SwayNC" -i software-update-available \
        "Manutencao do Sistema" \
        "Limpeza concluida. Ha $UPDATES pacotes disponiveis para atualizacao."
else
    if [ "$SILENT" = false ]; then
        notify-send -u low -a "SwayNC" -i dialog-information \
            "Manutencao do Sistema" \
            "Limpeza concluida com sucesso. Sistema atualizado."
    fi
fi

log_msg "Manutencao finalizada."
