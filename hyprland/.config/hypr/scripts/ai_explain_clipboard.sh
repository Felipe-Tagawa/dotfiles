#!/bin/bash
# ==============================================================================
# ai_explain_clipboard.sh - Explicação rápida do clipboard via Gemini / agy
# ==============================================================================

# Garantir PATH para agy, notify-send e wl-paste
export PATH="$HOME/.gemini/bin:$HOME/.local/bin:$PATH"

CLIP_TEXT=$(wl-paste 2>/dev/null)

if [ -z "$CLIP_TEXT" ]; then
    notify-send -a "SwayNC" -i dialog-warning "Gemini AI" "A área de transferência está vazia."
    exit 0
fi

# Limitar tamanho para análise rápida
TRUNCATED_TEXT=$(echo "$CLIP_TEXT" | head -n 40 | cut -c 1-1500)

notify-send -a "SwayNC" -i dialog-information -t 4000 "Gemini AI" "Analisando conteúdo do clipboard..."

PROMPT="Você é um assistente técnico direto e objetivo. Analise o seguinte texto copiado pelo usuário (que pode ser um erro de compilação, trecho de código, comando bash, log ou texto técnico).
Responda em português de forma concisa e prática (máximo 3 a 4 frases ou um comando sugerido), explicando o problema e como resolver:

\`\`\`
$TRUNCATED_TEXT
\`\`\`"

if command -v agy &>/dev/null; then
    RESPONSE=$(agy -p "$PROMPT" 2>/dev/null | sed 's/^[[:space:]]*//')
elif [ -n "$GEMINI_API_KEY" ] && command -v python3 &>/dev/null; then
    RESPONSE=$(python3 - << EOF 2>/dev/null
import os
from google import genai
try:
    client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
    res = client.models.generate_content(
        model="gemini-2.5-flash",
        contents="""$PROMPT"""
    )
    print(res.text.strip())
except Exception as e:
    print(f"Erro: {e}")
EOF
)
else
    RESPONSE="Nenhum backend de IA configurado (nem agy nem GEMINI_API_KEY)."
fi

if [ -n "$RESPONSE" ]; then
    notify-send -a "SwayNC" -i help-browser -t 15000 "Gemini Responde" "$RESPONSE"
else
    notify-send -a "SwayNC" -i dialog-error "Gemini AI" "Não foi possível obter resposta da IA."
fi
