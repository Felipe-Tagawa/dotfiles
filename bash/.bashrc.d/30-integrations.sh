# 30-integrations.sh: Miniconda, Prompt, Homebrew, Antigravity CLI

# >>> conda initialize >>>
if [ -f "$HOME/miniconda3/bin/conda" ]; then
    __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<

# Homebrew (Linuxbrew)
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Antigravity CLI
if [ -d "$HOME/.gemini/antigravity-cli/bin" ]; then
    export PATH="$HOME/.gemini/antigravity-cli/bin:$PATH"
fi

# Oh My Posh / Shell Prompt
if command -v oh-my-posh &>/dev/null && [ -f "$HOME/.poshthemes/pure.omp.json" ]; then
    eval "$(oh-my-posh init bash --config "$HOME/.poshthemes/pure.omp.json")"
else
    # Elegant fallback PS1 with git status support
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Fastfetch greeting on interactive launch
if [ -t 1 ] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
