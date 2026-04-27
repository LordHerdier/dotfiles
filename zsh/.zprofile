# ~/.zprofile
# Login shell configuration file

# --- Use Windows GnuPG inside WSL (so pass talks to gpg4win + pinentry) ---
export PATH="/mnt/c/Program Files (x86)/GnuPG/bin:$PATH"
export GPG_TTY=$(tty)

# Optional but recommended: keep WSL and Windows separate on purpose
unset GNUPGHOME
