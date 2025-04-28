# Usual aliases
alias c="clear"
alias q="exit"
alias nanosu="$PRIV nano"
alias visu="$PRIV nvim"
alias ls="exa -lgh --group-directories-first"
alias la="exa -lgha --group-directories-first"
alias apt="nala"
alias sshos='ssh brennwh@os.cs.siue.edu'
alias sshfsos='sshfs brennwh@os.cs.siue.edu:/home/brennwh ~/os/'
alias ..="cd ../"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias path="realpath"
alias ts="tailscale.exe"
alias proxmox='ssh root@192.168.50.50'

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

# Nagios devices one-liner
alias nagios='bash -c "cd /home/charlie/work/scripts/scrapeNagios && source venv/bin/activate && python3 scrapeNagios.py"'
alias nagios_save='d=$(date +%Y-%m-%d_%H-%M-%S) && mkdir -p ~/documents/nagios_history/"$d" && nagios > ~/documents/nagios_history/"$d"/nagios.log'

# Respawn docker container
function dc-respawn() {
    for container in $@; do
        dc kill $container && dc rm -f $container && dc up -d $container
    done
    dc logs -f $@
}


# Change OMP Theme
omp-theme() {
  if [ -z "$1" ]; then
    echo "Usage: omp-theme <theme>"
    return 1
  fi
  local newtheme="$1"
  # Replace the first line (assumed to be OMPTHEME=...) in ~/.bashrc with the new theme.
  sed -i "1s/.*/OMPTHEME=${newtheme}/" ~/.bashrc
  # Reload the updated .bashrc.
  source ~/.bashrc
}

