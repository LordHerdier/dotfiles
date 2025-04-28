#!/usr/bin/env bash
set -euo pipefail

# Usage info
usage() {
  cat <<EOF
Usage: $0 [--auto]

Options:
  --auto    Try to auto-detect environment (WSL, ARCH, SERVER)
  -h|--help Show this help message
EOF
  exit 1
}

# Parse flags
AUTO=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --auto) AUTO=true; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

# Determine environment
if $AUTO; then
  if grep -qi microsoft /proc/version; then
    ENV="WSL"
  elif [[ -f /etc/arch-release ]]; then
    ENV="ARCH"
  elif grep -qiE 'debian|ubuntu' /etc/os-release; then
    ENV="SERVER"
  else
    echo "Could not auto-detect environment." >&2
    exit 1
  fi
else
  echo "Select environment:"
  select choice in WSL ARCH SERVER; do
    if [[ -n $choice ]]; then
      ENV="$choice"
      break
    else
      echo "Invalid selection, try again."
    fi
  done
fi

echo ">>> Environment: $ENV"

# Package lists
ALL_PKGS="git curl htop make stow exa zoxide"
WSL_PKGS="nmap python3"
ARCH_GROUP="base-devel"
SERVER_PKGS="sudo build-essential"

# Install packages
case "$ENV" in
  WSL)
    sudo apt update
    sudo apt install -y $ALL_PKGS $WSL_PKGS
    ;;
  ARCH)
    sudo pacman -Sy --needed --noconfirm $ALL_PKGS $ARCH_GROUP
    ;;
  SERVER)
    sudo apt update
    sudo apt install -y $ALL_PKGS $SERVER_PKGS
    ;;
esac

# Clone and stow
DOTDIR="$HOME/dotfiles"
if [[ -d $DOTDIR ]]; then
  echo ">>> $DOTDIR already exists, pulling latest..."
  git -C "$DOTDIR" pull
else
  echo ">>> Cloning your dotfiles..."
  git clone git@github.com:LordHerdier/dotfiles.git "$DOTDIR"
fi

cd "$DOTDIR"

# … after cloning and cd "$DOTDIR" …

# Figure out what to stow
if [[ $ENV == "SERVER" ]]; then
  STOW_SETS=(bash git omp scripts)
else
  STOW_SETS=(bash git omp scripts zsh)
fi

echo ">>> Preparing to stow: ${STOW_SETS[*]}"

# 1. Backup any existing non-symlink targets
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"
echo ">>> Backing up existing files to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for pkg in "${STOW_SETS[@]}"; do
  pkg_dir="$DOTDIR/$pkg"
  # find every entry (file or dir) inside the package
  while IFS= read -r item; do
    # strip leading "./"
    rel="${item#./}"
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      backup_path="$BACKUP_DIR/$rel"
      mkdir -p "$(dirname "$backup_path")"
      echo "  • mv '$target' → '$backup_path'"
      mv "$target" "$backup_path"
    fi
  done < <(cd "$pkg_dir" && find . -mindepth 1)
done

# 2. Run stow now that conflicts are out of the way
echo ">>> Stowing…"
stow "${STOW_SETS[@]}"

echo "✅ Done! Old files are in $BACKUP_DIR and symlinks are live."

