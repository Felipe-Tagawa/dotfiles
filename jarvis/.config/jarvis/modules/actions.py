#!/usr/bin/env python3
from typing import Dict, Any

def build_system_context(memory: dict) -> str:
    user = memory.get("user_name", "Desenvolvedor")
    stacks = ", ".join(memory.get("preferred_stacks", []))
    prefs = memory.get("preferences", "")
    return (
        f"Voce e o JARVIS, assistente tecnico de desenvolvimento de software e automacao do {user}.\n"
        f"Linguagens e stacks principais do usuario: {stacks}.\n"
        f"Diretrizes: {prefs}\n"
        "Seja estritamente direto, pratico e conciso. Nao use emojis em suas respostas. "
        "Forneca codigo pronto, comandos ou explicacoes sem enrolacao."
    )

def prompt_autofix(content: str, context: Dict[str, Any], memory: dict) -> str:
    sys = build_system_context(memory)
    return f"""{sys}
O usuario encontrou um erro ou problema no codigo ou terminal abaixo:
Contexto do Projeto: {context.get('cwd', '')} | Janela: {context.get('title', '')}

```
{content}
```

ACAO NECESSARIA:
1. Identifique a causa raiz do erro em 1 ou 2 frases curtas.
2. Forneca a correcao exata do codigo ou o comando de terminal que resolve o problema.
"""

def prompt_refactor(code: str, memory: dict) -> str:
    sys = build_system_context(memory)
    return f"""{sys}
Refatore o codigo a seguir para maxima legibilidade, performance e boas praticas modernas (adicione tipagem se aplicavel):

```
{code}
```

Retorne o codigo refatorado pronto para uso, seguido de um breve resumo das melhorias feitas.
"""

def prompt_test(code: str, memory: dict) -> str:
    sys = build_system_context(memory)
    return f"""{sys}
Gere uma suite completa de testes unitarios para o codigo abaixo (usando o framework padrao da linguagem, ex: pytest, jest, go test, etc.):

```
{code}
```

Cubra casos de sucesso e casos de borda/erro.
"""

def prompt_explain(content: str, memory: dict) -> str:
    sys = build_system_context(memory)
    return f"""{sys}
Explique o codigo, regex ou erro a seguir de forma concisa e didatica em no maximo 3 ou 4 topicos:

```
{content}
```
"""

def prompt_general(query: str, clipboard: str, context: Dict[str, Any], memory: dict) -> str:
    sys = build_system_context(memory)
    clip_part = f"\nConteudo recente da area de transferencia:\n```\n{clipboard[:1500]}\n```" if clipboard else ""
    return f"""{sys}
Contexto do Diretorio do Projeto: {context.get('cwd', '')}
Janela Ativa: {context.get('class', '')} - {context.get('title', '')}{clip_part}

SOLICITACAO DO USUARIO:
"{query}"

Responda com precisao tecnica, fornecendo explicacoes diretas, codigo limpo ou comandos de terminal quando apropriado.
"""
