#!/usr/bin/env python3
import sys
import os
import json
import argparse
from pathlib import Path

JARVIS_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(JARVIS_DIR))

from modules.hyprland_ipc import get_current_context
from modules.vision import get_clipboard_text
from modules.engines import generate_ai_response
from modules.actions import (
    prompt_autofix,
    prompt_refactor,
    prompt_test,
    prompt_explain,
    prompt_general
)
from modules.executor import notify, copy_to_clipboard, open_interactive_session, view_response_in_popup

def load_json(filepath: Path) -> dict:
    if filepath.exists():
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    return {}

def main():
    config = load_json(JARVIS_DIR / "config.json")
    memory = load_json(JARVIS_DIR / "memory.json")
    
    parser = argparse.ArgumentParser(description="JARVIS - Desktop AI Assistant & Orchestrator")
    parser.add_argument("action", nargs="?", default="menu", choices=["menu", "autofix", "refactor", "test", "explain", "pair", "prompt", "query"])
    parser.add_argument("query", nargs="*", help="Texto da instrucao ou comando")
    parser.add_argument("--engine", choices=["agy", "ollama", "gemini"], help="Substitui o motor de IA para esta execucao")
    parser.add_argument("--no-copy", action="store_true", help="Nao copia automaticamente para o clipboard")
    parser.add_argument("--popup", action="store_true", help="Abre o resultado em um popup flutuante do Kitty")
    
    args = parser.parse_args()
    
    if args.engine:
        config["default_engine"] = args.engine

    context = get_current_context()
    clipboard = get_clipboard_text()
    
    # 1. Modo Interativo / Pair Programmer
    if args.action == "pair":
        notify("Jarvis Copilot", f"Iniciando sessao interativa no diretorio:\n{context['cwd']}", icon="utilities-terminal")
        open_interactive_session(context["cwd"], engine=config.get("default_engine", "agy"))
        return

    # 2. Modo Menu Spotlight
    if args.action == "menu":
        launcher_script = JARVIS_DIR / "ui" / "jarvis_menu.sh"
        if launcher_script.exists():
            os.execv("/bin/bash", ["bash", str(launcher_script)])
        return

    # Notificacao discreta de processamento
    notify("Jarvis", "Processando solicitacao...", icon="system-run", timeout_ms=3000)

    # 3. Montagem do Prompt
    prompt = ""
    action_title = "Jarvis Responde"
    
    if args.action == "autofix":
        action_title = "Auto-Fix Concluido"
        target_content = clipboard
        if not target_content:
            notify("Jarvis", "A area de transferencia esta vazia para realizar o Auto-Fix.", icon="dialog-warning")
            return
        prompt = prompt_autofix(target_content, context, memory)
        
    elif args.action == "refactor":
        action_title = "Codigo Refatorado"
        if not clipboard:
            notify("Jarvis", "Copie o codigo a ser refatorado para a area de transferencia.", icon="dialog-warning")
            return
        prompt = prompt_refactor(clipboard, memory)
        
    elif args.action == "test":
        action_title = "Testes Unitarios Gerados"
        if not clipboard:
            notify("Jarvis", "Copie a funcao para a qual deseja criar testes.", icon="dialog-warning")
            return
        prompt = prompt_test(clipboard, memory)
        
    elif args.action == "explain":
        action_title = "Explicacao Tecnica"
        if not clipboard:
            notify("Jarvis", "Copie o trecho de codigo ou erro para explicar.", icon="dialog-warning")
            return
        prompt = prompt_explain(clipboard, memory)
        
    elif args.action in ["prompt", "query"]:
        user_query = " ".join(args.query).strip()
        if not user_query:
            notify("Jarvis", "Por favor forneca uma instrucao.", icon="dialog-warning")
            return
        action_title = f"Jarvis: {user_query[:35]}"
        prompt = prompt_general(user_query, clipboard, context, memory)

    # Executa geracao com o motor de IA
    response = generate_ai_response(prompt, config, cwd=context["cwd"])
    
    # Entrega dos resultados
    if not args.no_copy:
        copy_to_clipboard(response)
        
    notify(action_title, response, icon="emblem-default", timeout_ms=8000)
    
    if args.popup:
        view_response_in_popup(response, title=action_title)
        
    print(response)

if __name__ == "__main__":
    main()
