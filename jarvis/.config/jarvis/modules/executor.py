#!/usr/bin/env python3
import subprocess
import tempfile
import os

def notify(title: str, message: str, app_name: str = "Jarvis", icon: str = "dialog-information", timeout_ms: int = 6000):
    """Envia notificacao nativa para o sistema."""
    try:
        subprocess.run([
            "notify-send",
            "-a", app_name,
            "-i", icon,
            "-t", str(timeout_ms),
            title,
            message[:1500]
        ], check=True)
    except Exception:
        pass

def copy_to_clipboard(text: str):
    """Copia o texto gerado para a area de transferencia do Wayland."""
    try:
        p = subprocess.Popen(["wl-copy"], stdin=subprocess.PIPE)
        p.communicate(input=text.encode("utf-8"))
    except Exception:
        pass

def open_interactive_session(cwd: str, engine: str = "agy"):
    """Abre uma janela suspensa do Kitty com o agente interativo."""
    if engine == "ollama":
        command = "ollama run llama3.1"
    else:
        command = "agy"
        
    cmd = [
        "kitty",
        "--class", "jarvis-scratchpad",
        "--title", "Jarvis Copilot",
        "--directory", cwd,
        "-e", "bash", "-c", f"echo 'JARVIS AGENT NO PROJETO: {cwd}'; {command}"
    ]
    try:
        subprocess.Popen(cmd)
    except Exception:
        pass

def view_response_in_popup(response_text: str, title: str = "Jarvis Responde"):
    """Abre uma janela flutuante exibindo a resposta completa com destaque."""
    with tempfile.NamedTemporaryFile("w", delete=False, suffix=".md", encoding="utf-8") as f:
        f.write(response_text)
        temp_file = f.name

    # Script para exibir a resposta e aguardar tecla para fechar
    script_cmd = f"cat '{temp_file}'; echo -e '\n\n[ Pressione qualquer tecla ou Q para fechar ]'; read -n 1 -s; rm -f '{temp_file}'"
    cmd = [
        "kitty",
        "--class", "jarvis-scratchpad",
        "--title", title,
        "-e", "bash", "-c", script_cmd
    ]
    try:
        subprocess.Popen(cmd)
    except Exception:
        pass
