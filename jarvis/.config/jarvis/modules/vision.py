#!/usr/bin/env python3
import subprocess
import os
from typing import Optional, Dict, Any

SNAPSHOT_PATH = "/tmp/jarvis_snapshot.png"

def capture_window_or_screen(window_context: Optional[Dict[str, Any]] = None) -> Optional[str]:
    """Captura imagem da janela ativa ou tela inteira via grim."""
    cmd = ["grim"]
    
    # Se tiver dimensões da janela ativa
    if window_context and "at" in window_context and "size" in window_context:
        at = window_context["at"]
        size = window_context["size"]
        if size[0] > 0 and size[1] > 0:
            geometry = f"{at[0]},{at[1]} {size[0]}x{size[1]}"
            cmd.extend(["-g", geometry])
            
    cmd.append(SNAPSHOT_PATH)
    
    try:
        subprocess.run(cmd, check=True, timeout=2, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if os.path.exists(SNAPSHOT_PATH) and os.path.getsize(SNAPSHOT_PATH) > 0:
            return SNAPSHOT_PATH
    except Exception:
        # Fallback para tela cheia
        try:
            subprocess.run(["grim", SNAPSHOT_PATH], check=True, timeout=2, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if os.path.exists(SNAPSHOT_PATH):
                return SNAPSHOT_PATH
        except Exception:
            pass
            
    return None

def get_clipboard_text() -> str:
    """Extrai texto atual da área de transferência."""
    try:
        out = subprocess.check_output(["wl-paste"], timeout=1)
        return out.decode("utf-8", errors="ignore").strip()
    except Exception:
        return ""
