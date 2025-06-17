# Only run for interactive shells
[[ -o interactive ]] || return

###############################################################################
# Environment & Theme Settings
###############################################################################
# Local bin path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Ruby bin path - only if ruby is installed
if command -v ruby &> /dev/null; then
    export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$PATH"
fi

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
compinit

# Set the oh-my-posh theme
export OMPTHEME=pure

# Initialize oh‑my‑posh for zsh (using your custom theme config) - only if installed
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init zsh --config $HOME/.oh-my-posh/themes/$OMPTHEME.omp.json)"
fi

# Default editor
export EDITOR=nvim

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

# Ctrl-R fuzzy search through history (need fzf installed) - only if fzf is available
if command -v fzf &> /dev/null; then
    bindkey '^R' fzf-history-widget
    autoload -Uz fzf-history-widget
fi

###############################################################################
# Aliases, Functions, and Extras
###############################################################################
# Source your custom aliases and functions from .bash_aliases (they're mostly portable)
if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

# Source scriptlets
if [ -f ~/.zsh_scriptlets ]; then
  source ~/.zsh_scriptlets
fi

# Source secrets
if [ -f ~/.secrets.zsh ]; then
    source ~/.secrets.zsh
fi

# Chatgpt completions - only if chatgpt is installed
if command -v chatgpt &> /dev/null; then
    . <(chatgpt --set-completions zsh)
fi

###############################################################################
# Oh My Zsh Framework
###############################################################################
# Set up oh‑my‑zsh (disable its theme if you prefer oh‑my‑posh for the prompt) - only if installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME=""  # Leave empty to avoid theme conflicts with oh-my-posh
    plugins=(git)
    source $ZSH/oh-my-zsh.sh
fi

# Initialize zoxide for zsh - only if installed
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# Re-Init OMP Theme - only if oh-my-posh and omp-theme are available
if command -v oh-my-posh &> /dev/null && command -v omp-theme &> /dev/null; then
    omp-theme ${OMPTHEME} > /dev/null
fi

###############################################################################
# Pyenv Setup
###############################################################################
# Init pyenv (python version manager) if installed
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"

    # Load pyenv-virtualenv if available
    if command -v pyenv-virtualenv-init > /dev/null; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

###############################################################################
# Nvm Setup
###############################################################################
# Init nvm (node version manager) if installed
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
