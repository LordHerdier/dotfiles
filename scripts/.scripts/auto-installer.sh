#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# ⬢ auto-installer.sh — Detect your Linux, pick your goodies, install ’em.
# ─────────────────────────────────────────────────────────────────────────────
#
# Usage:
#   ./auto-installer.sh           # interactively choose, no defaults
#   DEFAULT_PACKAGES="neovim,zsh" \
#   ./auto-installer.sh           # those two pre-selected
#   ./auto-installer.sh -d nodejs,python3,zoxide
#
# You can override defaults via:
#   - env var DEFAULT_PACKAGES (comma-sep keys)
#   - -d/--defaults flag
#
# Package keys: neovim, nodejs, pyenv, pyenv-virtualenv, chatgpt, rust,
# ruby, oh-my-posh, zoxide, paru (Arch only), emacs, exa, nala (Debian only),
# python3, newsboat, glow, zsh
# ─────────────────────────────────────────────────────────────────────────────

DEFAULT_PACKAGES="${DEFAULT_PACKAGES:-}"
while [ $# -gt 0 ]; do
  case "$1" in
    -d|--defaults)
      shift
      DEFAULT_PACKAGES="$1"
      shift
      ;;
    *) break ;;
  esac
done

# detect package manager
if   command -v apt-get >/dev/null 2>&1; then PKG="apt"
elif command -v yum     >/dev/null 2>&1; then PKG="yum"
elif command -v pacman  >/dev/null 2>&1; then PKG="pacman"
else
  echo "Unsupported distro: no apt-get, yum or pacman found" >&2
  exit 1
fi

# detect distro name
DISTRO="$(. /etc/os-release && echo "$NAME")"
echo "Detected distro: $DISTRO (using $PKG)"

# all possible packages
ITEM_NAMES=(
  "Neovim"
  "Node.js (via nvm)"
  "Pyenv"
  "Pyenv-virtualenv"
  "ChatGPT-CLI"
  "Rust (rustup)"
  "Ruby"
  "Oh My Posh"
  "Zoxide"
  "Emacs"
  "Exa"
  "Python3"
  "Newsboat"
  "Glow"
  "Zsh"
)
ITEM_KEYS=(
  neovim
  nodejs
  pyenv
  pyenv-virtualenv
  chatgpt
  rust
  ruby
  oh-my-posh
  zoxide
  emacs
  exa
  python3
  newsboat
  glow
  zsh
)

# distro-specific extras
if [ "$PKG" = "pacman" ]; then
  ITEM_NAMES+=( "Paru (AUR helper)" )
  ITEM_KEYS+=( paru )
elif [ "$PKG" = "apt" ]; then
  ITEM_NAMES+=( "Nala (apt front-end)" )
  ITEM_KEYS+=( nala )
fi

# figure out which keys are defaults
DEFAULT_IDX=()
if [ -n "$DEFAULT_PACKAGES" ]; then
  IFS=',' read -r -a want <<<"$DEFAULT_PACKAGES"
  for w in "${want[@]}"; do
    for i in "${!ITEM_KEYS[@]}"; do
      if [ "${ITEM_KEYS[i]}" = "$w" ]; then
        DEFAULT_IDX+=( $((i+1)) )
      fi
    done
  done
fi

# build array of default keys
DEFAULT_KEYS=()
for idx in "${DEFAULT_IDX[@]}"; do
  DEFAULT_KEYS+=( "${ITEM_KEYS[idx-1]}" )
done

# display defaults, if any
if [ "${#DEFAULT_KEYS[@]}" -gt 0 ]; then
  echo
  echo "Default packages to install: ${DEFAULT_KEYS[*]}"
else
  echo
  echo "No defaults set."
fi

# filter out defaults from the menu
MENU_NAMES=()
MENU_KEYS=()
for i in "${!ITEM_KEYS[@]}"; do
  key=${ITEM_KEYS[i]}
  if [[ ! " ${DEFAULT_KEYS[*]} " =~ " $key " ]]; then
    MENU_KEYS+=( "$key" )
    MENU_NAMES+=( "${ITEM_NAMES[i]}" )
  fi
done

# show menu of extras
echo
echo "Select additional packages to install by number (space-separated)."
if [ "${#MENU_KEYS[@]}" -eq 0 ]; then
  echo "(no extras available)"
  echo
  read -r -p "Press Enter to proceed with defaults only…" _
  CHOICE=""
else
  for i in "${!MENU_NAMES[@]}"; do
    printf "%2d) %s\n" $((i+1)) "${MENU_NAMES[i]}"
  done
  echo
  read -rp "Your choice: " CHOICE
fi

# build final selection: start with defaults
SELECTION=( "${DEFAULT_KEYS[@]}" )

# add any extras the user picked
if [ -n "${CHOICE// }" ]; then
  for n in $CHOICE; do
    if [[ "$n" =~ ^[0-9]+$ ]] \
      && [ "$n" -ge 1 ] \
      && [ "$n" -le "${#MENU_KEYS[@]}" ]; then
      SELECTION+=( "${MENU_KEYS[n-1]}" )
    else
      echo "Ignoring invalid entry: $n"
    fi
  done
fi

if [ "${#SELECTION[@]}" -eq 0 ]; then
  echo "Nothing selected. Exiting."
  exit 0
fi

# install loop
for pkg in "${SELECTION[@]}"; do
  case "$pkg" in
    neovim)
      echo; echo "Installing Neovim"
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
      sudo rm -rf /opt/nvim
      sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
      ;;
    nodejs)
      echo; echo "Installing Node.js via nvm"
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
      . "$HOME/.nvm/nvm.sh"
      nvm install node
      ;;
    pyenv)
      echo; echo "Installing pyenv"
      curl -fsSL https://pyenv.run | bash
      ;;
    pyenv-virtualenv)
      echo; echo "Installing pyenv-virtualenv"
      git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)"/plugins/pyenv-virtualenv
      ;;
    chatgpt)
      echo; echo "Installing ChatGPT-CLI"
      if curl -fSL https://raw.githubusercontent.com/0xacx/chatGPT-shell-cli/main/install.sh \
           | sudo -E bash; then
        echo "ChatGPT-CLI installed"
      else
        echo "Failed to install ChatGPT-CLI"
      fi
      ;;
    rust)
      echo; echo "Installing Rust (rustup)"
      curl https://sh.rustup.rs -sSf | sh
      ;;
    ruby)
      echo; echo "Installing Ruby"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get update
        sudo apt-get install -y ruby-full
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y ruby
      else
        sudo pacman -S --needed --noconfirm ruby
      fi
      ;;
    oh-my-posh)
      echo; echo "Installing Oh My Posh"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get update
        sudo apt-get install -y unzip
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y unzip
      else
        sudo pacman -S --needed --noconfirm unzip
      fi
      curl -s https://ohmyposh.dev/install.sh | bash -s
      ;;
    zoxide)
      echo; echo "Installing zoxide"
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
      ;;
    paru)
      echo; echo "Installing Paru (AUR helper)"
      sudo pacman -S --needed base-devel git
      git clone https://aur.archlinux.org/paru.git
      cd paru && makepkg -si && cd ..
      ;;
    emacs)
      echo; echo "Installing Emacs"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get install -y emacs
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y emacs
      else
        sudo pacman -S --needed --noconfirm emacs
      fi
      ;;
    exa)
      echo; echo "Installing exa"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get install -y exa
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y exa
      else
        sudo pacman -S --needed --noconfirm exa
      fi
      ;;
    nala)
      echo; echo "Installing Nala"
      if [ "$PKG" != "apt" ]; then
        echo "Skipping nala: only on Debian/Ubuntu"
      else
        sudo apt-get install -y nala
      fi
      ;;
    python3)
      echo; echo "Installing Python3 and pip"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get install -y python3 python3-pip
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y python3 python3-pip
      else
        sudo pacman -S --needed --noconfirm python python-pip
      fi
      ;;
    newsboat)
      echo; echo "Installing Newsboat"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get install -y newsboat
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y newsboat
      else
        sudo pacman -S --needed --noconfirm newsboat
      fi
      ;;
    glow)
      echo; echo "Installing Glow"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get install -y glow
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y glow
      else
        sudo pacman -S --needed --noconfirm glow
      fi
      ;;
    zsh)
      echo; echo "Installing Zsh"
      if [ "$PKG" = "apt" ]; then
        sudo apt-get install -y zsh
      elif [ "$PKG" = "yum" ]; then
        sudo yum install -y zsh
      else
        sudo pacman -S --needed --noconfirm zsh
      fi
      ;;
    *)
      echo; echo "Unknown package key: $pkg"
      ;;
  esac
done

echo
echo "All done."
