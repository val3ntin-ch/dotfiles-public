# $ZDOTDIR/.zprofile  (~/.config/zsh/.zprofile)
# Login shell only — runs once when you open a terminal app or SSH in.
# NOT run for every new tab (unless your terminal opens login shells).
# Use for: things that spawn subprocesses (brew shellenv, pyenv init, etc.)

# ── Homebrew shellenv (macOS) ─────────────────────────────────────────────
# Sets HOMEBREW_CELLAR, HOMEBREW_REPOSITORY, INFOPATH, MANPATH correctly.
# Can't go in .zshenv because it spawns a subprocess (forks a new process).
# Try Apple Silicon first, then Intel — portable across both architectures.
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"      # Apple Silicon
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"         # Intel Mac
  fi
fi

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

# fnm — Node version manager (also in .zshrc for interactive shells)
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"
