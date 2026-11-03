# 10-aliases.sh: Shell Aliases & Functions

# Colored ls and defaults
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias clear='command clear && command -v fastfetch &>/dev/null && fastfetch'

# System Management
alias desligar='sudo shutdown now'
alias reiniciar='sudo reboot'
alias upgrade='system-upgrade'
alias sudo='sudo '

# Clipboard (Wayland)
alias copiar='wl-copy'
alias colar='wl-paste'

# Developer & Editor shortcuts
alias code='/usr/bin/code'
alias browser='firefox'
alias dotsync='dotfiles-sync'
alias aicommit='git-aicommit'
alias drive='$HOME/.local/bin/abrir_drive.sh'
alias teams='$HOME/.local/bin/abrir_teams.sh'
alias teams-clean='$HOME/.local/bin/abrir_teams.sh --only-clean'
alias tablet='scrcpy --max-fps=60 -b 16M --no-control'

# Alert notification for long commands (e.g., sleep 10; alert)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Memory management (if scripts exist)
if [ -d "$HOME/scripts" ]; then
    alias memoria-monitor='bash "$HOME/scripts/monitorar-memoria.sh"'
    alias memoria-limpar='sudo bash "$HOME/scripts/limpar-memoria.sh"'
    alias memoria-servicos='bash "$HOME/scripts/gerenciar-servicos-memoria.sh"'
    alias memoria-log='sudo tail -f /var/log/memoria-auto.log'
fi
