# ~/.zprofile
# Login shell configuration file

# ──────────────────────────────────────────────────────
# DAILY Bash.org MOTD: run ~/bin/wut once per day, then stamp the date
# ──────────────────────────────────────────────────────
[[ -z $PS1 ]] && return   # bail on non‑interactive


local wut_cmd="$HOME/bin/wut"
local stamp_file="$HOME/.last_wut_date"
local today=$(date +%F)    # YYYY‑MM‑DD

if [[ -x $wut_cmd ]]; then
  if [[ ! -f $stamp_file ]] || [[ $(<"$stamp_file") != $today ]]; then
    # run your masterpiece
    "$wut_cmd"
    # update the stamp
    print -r -- $today >| "$stamp_file"
  fi
fi


# --- Use Windows GnuPG inside WSL (so pass talks to gpg4win + pinentry) ---
export PATH="/mnt/c/Program Files (x86)/GnuPG/bin:$PATH"
export GPG_TTY=$(tty)

# Optional but recommended: keep WSL and Windows separate on purpose
unset GNUPGHOME
