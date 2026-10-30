#!/usr/bin/env bash
# =============================================================================
# Microsoft Teams Launcher & Comprehensive Cache Purger (Firefox)
# Soluciona o bug crônico de loading infinito/tela branca no Firefox:
# - Remove completamente os diretórios de storage (OPFS / IndexedDB / LocalStorage)
# - Desregistra os ServiceWorkers corrompidos em serviceworker.txt
# - Preserva a autenticação em cookies.sqlite (não precisa logar do zero se válido)
# =============================================================================

limpar_cache_teams() {
    python3 - <<'EOF'
import os, shutil, glob

firefox_dir = os.path.expanduser("~/.config/mozilla/firefox")
if not os.path.isdir(firefox_dir):
    exit(0)

for profile in glob.glob(os.path.join(firefox_dir, "*.*")):
    if not os.path.isdir(profile):
        continue

    # 1. Remove diretórios inteiros de storage default e permanent
    for scope in ["default", "permanent"]:
        storage_dir = os.path.join(profile, "storage", scope)
        if os.path.isdir(storage_dir):
            patterns = [
                "*teams*",
                "*assignments.edu.cloud.microsoft*"
            ]
            for pat in patterns:
                for target in glob.glob(os.path.join(storage_dir, pat)):
                    try:
                        shutil.rmtree(target, ignore_errors=True)
                    except Exception:
                        pass

    # 2. Desregistra os ServiceWorkers órfãos do Teams
    sw_file = os.path.join(profile, "serviceworker.txt")
    if os.path.isfile(sw_file):
        try:
            with open(sw_file, "r", encoding="utf-8", errors="ignore") as f:
                lines = f.readlines()
            filtered = [
                line for line in lines
                if "teams.cloud.microsoft" not in line
                and "teams.microsoft.com" not in line
            ]
            if len(filtered) != len(lines):
                with open(sw_file, "w", encoding="utf-8") as f:
                    f.writelines(filtered)
        except Exception:
            pass

print("Caches e ServiceWorkers corrompidos do Teams eliminados com sucesso.")
EOF
}

echo "Limpando caches obsoletos e ServiceWorkers do Teams..."
limpar_cache_teams

if [ "$1" = "--only-clean" ] || [ "$1" = "-c" ]; then
    echo "Pronto! O cache do Teams foi completamente limpo."
    exit 0
fi

echo "Iniciando Microsoft Teams no Firefox..."
exec firefox --new-window "https://teams.cloud.microsoft" &
