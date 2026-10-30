# =============================================================================
# ~/.bashrc: Executed by bash(1) for non-login interactive shells.
# Modular Dotfiles Architecture
# =============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source all modular configuration files from ~/.bashrc.d/
if [ -d "$HOME/.bashrc.d" ]; then
    for rc in "$HOME"/.bashrc.d/*.sh; do
        if [ -r "$rc" ]; then
            . "$rc"
        fi
    done
    unset rc
fi

# Optional local overrides not committed to git
if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi

export PATH=$PATH:/home/kyo/.spicetify
