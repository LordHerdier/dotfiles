# Only run for interactive shells
case $- in
    *i*) ;;
      *) return;;
esac

###############################################################################
# Environment & Theme Settings
###############################################################################
# Variables
OMPTHEME=json.custom

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# If ruby is installed, add it to the path
if command -v ruby &> /dev/null; then
    export PATH="$HOME/.local/share/gem/ruby/**/bin:$PATH"
fi

# If cargo is installed, add it to the path and source the env
if command -v cargo &> /dev/null; then
    export PATH="$HOME/.cargo/bin:$PATH"
    . "$HOME/.cargo/env"
fi

# Init zoxide (better cd alternative)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash --cmd cd)"
fi

# Init oh-my-posh (better prompt)
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init bash --config $HOME/.oh-my-posh/themes/$OMPTHEME.omp.json)"
fi

# set terminal color mode detection  
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Enable chatgpt completions (if installed)
if command -v chatgpt &> /dev/null; then
    . <(chatgpt --set-completions bash)
fi

###############################################################################
# History & Options 
###############################################################################
HISTCONTROL=ignoreboth
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# Ignore duplicate history entries
bind 'set show-all-if-ambiguous on'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Enable case-insensitive tab completion
bind "set completion-ignore-case on"

# Enable auto-suggestion
bind '"\C-r": reverse-search-history'

###############################################################################
# Pyenv Setup
###############################################################################
# Init pyenv (python version manager) if installed
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    
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
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

###############################################################################
# Aliases, Functions, Scripts, etc.
###############################################################################
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_scriptlets ]; then
    . ~/.bash_scriptlets
fi
