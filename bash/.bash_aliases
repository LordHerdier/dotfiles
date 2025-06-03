# Usual aliases
alias c="clear"
alias ccd="clear && cd ~"
alias cdc="ccd"
alias q="exit"
alias nanosu="$PRIV nano"
alias visu="$PRIV nvim"
alias em="emacs -nw"
alias ls="exa -lgh --group-directories-first"
alias la="exa -lgha --group-directories-first"
alias ll="exa -lg --group-directories-first"
alias apt="nala"
alias ..="cd ../"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias path="realpath"
alias ts="tailscale.exe"
alias files='explorer.exe .'
alias venvc='python3 -m venv venv'
alias venva='source venv/bin/activate'
alias olivetin='sudo service OliveTin start'
alias ip='ip -h -c'
alias pl='please'
alias reload='source ~/.bashrc && echo "💥 bashrc reloaded!"'
alias nb='newsboat && clear'
alias md='glow'

# ChatGPT shortcut
alias ch='chatgpt'

# Quick SSH shortcuts
alias proxmox='ssh root@192.168.50.50'
alias htpc='ssh charlotte@htpc.local.lorscapa.com'
alias vc4='ssh brennwh@edw-vc4.isg.siue.edu'
alias pve2='ssh root@192.168.50.174'

# Docker aliases
alias dc="docker compose"
alias dcu="docker compose up"
alias dcud="docker compose up -d"
alias dcuf="docker compose up --force-recreate"
alias dcudf="docker compose up -d --force-recreate"
alias dcd="docker compose down"
alias dcs="docker compose stop"
alias dcp="docker compose pull"
alias dcl="docker compose logs"
alias dclf="docker compose logs --follow"

# Git-branching helper functions (Bash-style)
gcb() {
    git checkout -b "$1"
}

gco() {
    git checkout "$1"
}

gpo() {
    git push origin HEAD
}

# bruh alias to force your system to use /usr/bin/npm
alias npm='/usr/bin/npm'