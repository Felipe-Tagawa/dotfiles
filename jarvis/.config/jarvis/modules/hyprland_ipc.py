#!/usr/bin/env python3
import json
import os
import subprocess
from pathlib import Path
from typing import Dict, Any, Optional

def get_active_window() -> Dict[str, Any]:
    """Retorna metadados da janela atualmente focada no Hyprland."""
    try:
        out = subprocess.check_output(["hyprctl", "activewindow", "-j"], timeout=1)
        data = json.loads(out.decode("utf-8"))
        if isinstance(data, dict):
            return data
    except Exception:
        pass
    return {}

def get_process_cwd(pid: int) -> str:
    """Descobre o diretório de trabalho corrente do processo pelo /proc."""
    if not pid or pid <= 0:
        return str(Path.home())
    
    # Tenta checar os filhos do processo caso seja um terminal (Kitty, Alacritty)
    try:
        children_dir = f"/proc/{pid}/task/{pid}/children"
        if os.path.exists(children_dir):
            with open(children_dir, "r") as f:
                children = f.read().strip().split()
                if children:
                    last_child = int(children[-1])
                    child_cwd = os.readlink(f"/proc/{last_child}/cwd")
                    if os.path.exists(child_cwd):
                        return child_cwd
    except Exception:
        pass

    try:
        cwd = os.readlink(f"/proc/{pid}/cwd")
        if os.path.exists(cwd):
            return cwd
    except Exception:
        pass

    return str(Path.home())

def get_current_context() -> Dict[str, Any]:
    """Agrega o contexto completo da área de trabalho."""
    win = get_active_window()
    pid = win.get("pid", 0)
    cwd = get_process_cwd(pid) if pid else str(Path.home())
    
    return {
        "title": win.get("title", ""),
        "class": win.get("class", ""),
        "pid": pid,
        "at": win.get("at", [0, 0]),
        "size": win.get("size", [0, 0]),
        "workspace": win.get("workspace", {}).get("name", "1"),
        "cwd": cwd,
    }

if __name__ == "__main__":
    print(json.dumps(get_current_context(), indent=2))
