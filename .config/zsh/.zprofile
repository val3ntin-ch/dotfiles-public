# $ZDOTDIR/.zprofile  (~/.config/zsh/.zprofile)
# Login shell only — runs once when you open a terminal app or SSH in.
# NOT run for every new tab (unless your terminal opens login shells).
# Use for: things that spawn subprocesses (brew shellenv, pyenv init, etc.)

# ── Homebrew shellenv (macOS) ─────────────────────────────────────────────
# Sets HOMEBREW_CELLAR, HOMEBREW_REPOSITORY, INFOPATH, MANPATH correctly.
# Can't go in .zshenv because it spawns a subprocess (forks a new process).
#
# FEYNMAN — why hardcode the path here?
# We try Apple Silicon (/opt/homebrew) first, then Intel (/usr/local).
# This makes the config portable across both Mac architectures without
# depending on HOMEBREW_PREFIX being set yet (it isn't, at this point).
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"      # Apple Silicon
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"         # Intel Mac
  fi
fi

# ── NVM (Node Version Manager) ────────────────────────────────────────────
# FEYNMAN — why NVM here and not in .zshenv?
#
# nvm.sh is ~3000 lines of shell script that defines the `nvm` function.
# Sourcing it takes ~40-80ms. We do it once per login shell (here) not
# once per every new tab/pane (which would be .zshrc).
#
# nvm bash_completion adds Tab completion for nvm subcommands.
# NVM_DIR is already exported in .zshenv so it's visible to scripts.
#
# NOTE: If you migrate to fnm (10x faster, Rust-based), replace these
# two lines with: eval "$(fnm env --use-on-cd)" in this same block.
[ -s "$NVM_DIR/nvm.sh" ]             && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]    && source "$NVM_DIR/bash_completion"

# ── Version managers (login shell only) ──────────────────────────────────

# pyenv — Python version manager
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  eval "$(pyenv init - --no-rehash zsh)"
fi

# rbenv — Ruby version manager
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# fnm — Fast Node Manager (use instead of nvm if you migrate)
# If both nvm and fnm are present, fnm takes precedence — comment out
# the NVM block above if you switch.
if command -v fnm &>/dev/null && [[ -z "$NVM_DIR" || ! -s "$NVM_DIR/nvm.sh" ]]; then
  eval "$(fnm env --use-on-cd --log-level quiet)"
fi
