# Only run for interactive shells
[[ -o interactive ]] || return

###############################################################################
# Environment & Theme Settings
###############################################################################
# Local bin path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# If cargo is installed, add it to the path
if command -v cargo &> /dev/null; then
    export PATH="$HOME/.cargo/bin:$PATH"
    . "$HOME/.cargo/env"
fi

# If nvim dir exists, add it to the path
if [ -f "/opt/nvim/nvim" ]; then
    export PATH="$PATH:/opt/nvim/"
fi

autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# Set the oh-my-posh theme from file
if [ -f "$HOME/.omp_current" ]; then
    export OMPTHEME=$(cat "$HOME/.omp_current" | tr -d '\n')
else
    export OMPTHEME=pure  # fallback default
fi

# Initialize oh‑my‑posh for zsh (using your custom theme config) - only if installed
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init zsh --config $HOME/.oh-my-posh/themes/$OMPTHEME.omp.json)"
fi

# Initialize zoxide for zsh - only if installed
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# Default editor
export EDITOR=nvim

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# ---- ssh-agent (WSL-proof) ----
if [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"
fi

# Start agent if socket doesn't exist / isn't a socket
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  mkdir -p "${XDG_RUNTIME_DIR:-/tmp}"
  eval "$(ssh-agent -a "$SSH_AUTH_SOCK" -s)" >/dev/null
fi

###############################################################################
# History & Completion Settings
###############################################################################
# Set history file and sizes
HISTFILE=~/.zsh_history
HISTSIZE=3000
SAVEHIST=5000

# Append history rather than overwriting it, and share history among sessions
setopt append_history inc_append_history share_history

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Don't append commands that start with a space to history
setopt HIST_IGNORE_SPACE

###############################################################################
# Oh My Zsh Framework
###############################################################################
# Set up oh‑my‑zsh (disable its theme if you prefer oh‑my‑posh for the prompt) - only if installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"

    ZSH_THEME=""  # Leave empty to avoid theme conflicts with oh-my-posh
    plugins=(docker fzf git git-auto-fetch pass pip ssh)
    source $ZSH/oh-my-zsh.sh
fi


###############################################################################
# Aliases, Functions, and Extras
###############################################################################
for file in ~/.zsh_aliases ~/.zsh_scriptlets ~/.secrets.zsh ~/.ssh_aliases.zsh; do
    [ -f "$file" ] && source "$file"
done


###############################################################################
# Pyenv Setup
###############################################################################
# Init pyenv (python version manager) if installed - lazy load for faster startup
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    
    # Lazy load pyenv to speed up shell startup
    pyenv() {
        eval "$(command pyenv init - zsh)"
        [ -s "$HOME/.pyenv/versions/pyenv-virtualenv" ] && eval "$(command pyenv virtualenv-init -)"
        pyenv "$@"
    }
fi


###############################################################################
# Atuin
###############################################################################
export PATH="$PATH:$HOME/.atuin/bin"
eval "$(atuin init zsh)"
