# Only run for interactive shells
[[ -o interactive ]] || return

###############################################################################
# Environment & Theme Settings
###############################################################################
# Local bin path
export PATH="$HOME/.local/bin:$PATH"

export DOT="$HOME/.dotfiles"
export PATH="$DOT/bin/bin:$PATH"

# Set your oh‑my‑posh theme (migrated from OMPTHEME in your .bashrc)
export OMPTHEME=json.custom

# Initialize oh‑my‑posh for zsh (using your custom theme config)
eval "$(oh-my-posh init zsh --config $HOME/.oh-my-posh/themes/$OMPTHEME.omp.json)"

###############################################################################
# History & Completion Settings
###############################################################################
# Set history file and sizes
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000

# Append history rather than overwriting it, and share history among sessions
setopt append_history inc_append_history share_history

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############################################################################
# Aliases, Functions, and Extras
###############################################################################
# Source your custom aliases and functions from .bash_aliases (they’re mostly portable)
if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

# Crestron command function (as in your .bashrc)
function crestroncmd() {
  local device="$1"
  shift
  # Append domain if needed
  if [[ ! "$device" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [[ "$device" != *".id.siue.edu" ]]; then
    device="${device}.id.siue.edu"
  fi
  local cmd="$*"
  /mnt/c/windows/System32/WindowsPowerShell/v1.0/powershell.exe "C:\Users\brennwh\Documents\scripts\management-scripts\EDK\crestronCmd.ps1" \
      -Device "$device" -Command "$cmd"
}

###############################################################################
# Oh My Zsh Framework
###############################################################################
# Set up oh‑my‑zsh (disable its theme if you prefer oh‑my‑posh for the prompt)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Leave empty to avoid theme conflicts with oh-my-posh
plugins=(git)
source $ZSH/oh-my-zsh.sh

# You can add additional customizations below as needed...


# Initialize zoxide for zsh
eval "$(zoxide init zsh --cmd cd)"

# Re-Init OMP Theme
omp-theme ${OMPTHEME} > /dev/null

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Load pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"
