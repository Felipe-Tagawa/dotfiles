# =============================================================================
# 00-env.sh: Environment Variables, PATH & History
# =============================================================================

# Default Applications
export BROWSER="firefox"

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="$PATH:$HOME/.spicetify"

if [ -d "$HOME/Flutter/flutter/bin" ]; then
    export PATH="$HOME/Flutter/flutter/bin:$PATH"
fi

if [ -d "/opt/spark" ]; then
    export SPARK_HOME="/opt/spark"
    export PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"
fi

# XDG History and state paths
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000
shopt -s histappend
shopt -s checkwinsize

mkdir -p "$HOME/.local/state/bash" "$HOME/.local/state/less" "$HOME/.local/state/wget" 2>/dev/null
export HISTFILE="$HOME/.local/state/bash/history"
export LESSHISTFILE="$HOME/.local/state/less/history"
export WGET_HSTS_FILE="$HOME/.local/state/wget/hsts"

# Lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
