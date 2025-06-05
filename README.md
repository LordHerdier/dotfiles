# Charlie's Dotfiles

> **⚠️ Personal Setup Warning**: This repository is my personal dotfiles configuration, tailored specifically for my workflow and environment. It's **not designed to be used by others as-is** and will likely break things if you try to apply it directly to your system. 
>
> **However**, you're absolutely welcome to browse through, steal ideas, copy snippets, or adapt anything you find useful! That's what open source is all about. 🎉

## What's Inside

This is a [GNU Stow](https://www.gnu.org/software/stow/)-based dotfiles setup that manages configurations for various tools and environments I use daily.

### 🐚 Shell Configurations
- **Bash** (`bash/`): Complete bash setup with aliases, functions, and a comprehensive `.bashrc`
- **Zsh** (`zsh/`): Zsh configuration with aliases and custom functions
- **Oh-My-Posh** (`omp/`): Beautiful terminal prompts with custom themes

### 📝 Text Editors & Tools
- **Emacs** (`emacs/`): My Emacs configuration for when I want that classic editor experience
- **Neomutt** (`neomutt/`): Email client configuration
- **Newsboat** (`newsboat/`): RSS feed reader setup

### 🛠️ Utility Scripts (`bin/`)
A collection of utility scripts that make my life easier:
- `choose-omp-theme`: Interactive Oh-My-Posh theme selector
- `dc-respawn`: Docker Compose service restart helper
- `myip`: Show local and external IP addresses
- `repeatcmd`: Run commands at intervals
- `extract`: Universal archive extractor
- `nagios`: Nagios monitoring script launcher
- Plus several others for various specific tasks

### 🚀 Bootstrap Script (`scripts/`)
An automated setup script that:
- Detects your environment (WSL, Arch Linux, or Debian/Ubuntu server)
- Installs necessary packages
- Clones this repo and sets up symlinks with Stow
- Backs up existing dotfiles before replacing them

## Environment Support

The bootstrap script supports three main environments:
- **WSL** (Windows Subsystem for Linux)
- **Arch Linux** 
- **Debian/Ubuntu Server**

Each gets its own package set and configuration tweaks.

## How It Works

This setup uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks. Each directory (like `bash/`, `zsh/`, `bin/`) is a "stow package" that gets symlinked into your home directory.

For example:
- `bash/.bashrc` → `~/.bashrc`
- `bin/bin/myip` → `~/bin/myip`
- `emacs/.emacs.d/init.el` → `~/.emacs.d/init.el`

## Quick Setup (For the Brave)

```bash
# Clone the repo
git clone https://github.com/LordHerdier/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the bootstrap script
./scripts/.scripts/bootstrap.sh --auto
```

But seriously, **don't do this** unless you want to potentially mess up your existing setup. The script does create backups, but still...

## What You Might Want to Steal

Here are some potentially useful bits you might want to adapt:

### Bash Functions (`bash/.bash_scriptlets`)
- `please()`: Re-run the last command with sudo
- `mkcd()`: Create directory and cd into it
- `omp-theme()`: Switch Oh-My-Posh themes on the fly

### Aliases (`bash/.bash_aliases`)
- Docker Compose shortcuts (`dc`, `dcu`, `dcd`, etc.)
- Git helpers (`gcb`, `gco`, `gpo`)
- System navigation shortcuts

### Utility Scripts
- `bin/myip`: Python script to show local and external IPs
- `bin/repeatcmd`: Bash script to repeat commands at intervals
- `bin/extract`: Universal archive extraction script

### Bootstrap Approach (`scripts/.scripts/bootstrap.sh`)
- Environment detection logic
- Stow-based dotfile management
- Backup system for existing files

## Dependencies

The setup expects these tools to be available:
- `git`, `curl`, `stow` (essential)
- `exa` (better `ls`)
- `zoxide` (better `cd`)
- `oh-my-posh` (pretty prompts)
- Various others depending on what you use

## Contributing

This is my personal setup, so I'm not really looking for contributions. But if you spot a bug or have a suggestion, feel free to open an issue!

## License

Do whatever you want with this code. Take it, adapt it, improve it, break it - I don't care. Just don't blame me if it breaks your system. 😄

---

*Remember: These are **my** dotfiles. They work for **my** workflow on **my** systems. Your mileage may vary dramatically. You've been warned!* 🚨 