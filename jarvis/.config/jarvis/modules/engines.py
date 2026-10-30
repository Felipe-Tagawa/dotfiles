#!/usr/bin/env python3
import json
import os
import subprocess
import urllib.request
import urllib.error
from typing import Optional

def query_agy(prompt: str, cwd: Optional[str] = None) -> Optional[str]:
    """Executa prompt via Antigravity CLI (agy)."""
    cmd = ["agy", "-p", prompt]
    try:
        res = subprocess.run(
            cmd,
            cwd=cwd or os.path.expanduser("~"),
            capture_output=True,
            text=True,
            timeout=30
        )
        if res.returncode == 0 and res.stdout.strip():
            return res.stdout.strip()
    except Exception:
        pass
    return None

def query_ollama(prompt: str, model: str = "llama3.1", host: str = "http://127.0.0.1:11434") -> Optional[str]:
    """Consulta modelo local no Ollama via HTTP API."""
    url = f"{host.rstrip('/')}/api/generate"
    payload = json.dumps({
        "model": model,
        "prompt": prompt,
        "stream": False
    }).encode("utf-8")
    
    req = urllib.request.Request(
        url,
        data=payload,
        headers={"Content-Type": "application/json"}
    )
    
    try:
        with urllib.request.urlopen(req, timeout=40) as response:
            if response.status == 200:
                data = json.loads(response.read().decode("utf-8"))
                return data.get("response", "").strip()
    except Exception:
        pass
    return None

def query_gemini_api(prompt: str, api_key: str) -> Optional[str]:
    """Consulta direta a API REST do Gemini."""
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    payload = json.dumps({
        "contents": [{"parts": [{"text": prompt}]}]
    }).encode("utf-8")
    
    req = urllib.request.Request(
        url,
        data=payload,
        headers={"Content-Type": "application/json"}
    )
    
    try:
        with urllib.request.urlopen(req, timeout=25) as response:
            if response.status == 200:
                data = json.loads(response.read().decode("utf-8"))
                candidates = data.get("candidates", [])
                if candidates:
                    parts = candidates[0].get("content", {}).get("parts", [])
                    if parts:
                        return parts[0].get("text", "").strip()
    except Exception:
        pass
    return None

def generate_ai_response(prompt: str, config: dict, cwd: Optional[str] = None) -> str:
    """Orquestra a geracao de resposta usando o motor preferido com fallback inteligente."""
    engine = config.get("default_engine", "agy")
    fallback = config.get("fallback_engine", "ollama")
    
    # 1. Tenta motor padrao
    if engine == "agy":
        res = query_agy(prompt, cwd=cwd)
        if res:
            return res
    elif engine == "ollama":
        res = query_ollama(prompt, model=config.get("ollama_model", "llama3.1"), host=config.get("ollama_host", "http://127.0.0.1:11434"))
        if res:
            return res

    # 2. Tenta motor de fallback
    if fallback == "ollama" and engine != "ollama":
        res = query_ollama(prompt, model=config.get("ollama_model", "llama3.1"), host=config.get("ollama_host", "http://127.0.0.1:11434"))
        if res:
            return res
    elif fallback == "agy" and engine != "agy":
        res = query_agy(prompt, cwd=cwd)
        if res:
            return res

    # 3. Tenta GEMINI_API_KEY no ambiente
    api_key = os.environ.get("GEMINI_API_KEY")
    if api_key:
        res = query_gemini_api(prompt, api_key)
        if res:
            return res

    return "Jarvis: Nao foi possivel obter resposta dos motores de IA configurados (agy, ollama ou api). Verifique se o servico do Ollama ou agy esta disponivel."
