# $ZDOTDIR/conf.d/completions.zsh
# ══════════════════════════════════════════════════════════════════════════════
# FEYNMAN — why a separate completions file?
#
# compinit already ran in .zshrc (§1). Now we add completions from tools
# that generate their own completion scripts at runtime (gh, docker, pnpm…).
#
# The naive approach: `eval "$(tool completion zsh)"` on every shell start.
# Problem: each eval forks a process and parses output = slow startup.
#
# The smart approach: generate the completion once, cache it to a file,
# source the file on every start. Only regenerate when the tool binary changes
# (detected by comparing mtime of binary vs cache file).
#
# _cache_completion handles this pattern for any tool.
# ══════════════════════════════════════════════════════════════════════════════

# Helper: generate + cache a completion script
# Usage: _cache_completion <toolname> <args to generate completion>
# Example: _cache_completion gh completion -s zsh
_cache_completion() {
  local tool="$1"; shift
  local cache="$XDG_CACHE_HOME/zsh/${tool}-completion.zsh"
  local bin
  bin="$(command -v "$tool" 2>/dev/null)" || return 0   # tool not installed: skip silently

  # Regenerate if: cache doesn't exist OR binary is newer than cache
  if [[ ! -f "$cache" || "$bin" -nt "$cache" ]]; then
    "$tool" "$@" > "$cache" 2>/dev/null
  fi

  [[ -f "$cache" && -s "$cache" ]] && source "$cache"
}

# ── Tool completions ──────────────────────────────────────────────────────
_cache_completion gh          completion -s zsh        # GitHub CLI
_cache_completion docker      completion zsh           # Docker
_cache_completion kubectl     completion zsh           # Kubernetes
_cache_completion helm        completion zsh           # Helm
_cache_completion pnpm        completion zsh           # pnpm
_cache_completion rustup      completions zsh          # Rust toolchain
_cache_completion starship    completions zsh          # Starship
_cache_completion fnm         completions --shell zsh  # Fast Node Manager

# ── eza completions ────────────────────────────────────────────────────────
# eza ships its own _eza completion file, installed by Homebrew into the
# site-functions fpath (already added in .zshrc). compinit finds it automatically.
# Nothing extra needed here.

# ── fzf completions ────────────────────────────────────────────────────────
# fzf's completion.zsh is sourced inside zvm_after_init() in .zshrc to ensure
# it survives vi-mode's keymap reset. Nothing to do here.

# ── Additional zstyle tuning ──────────────────────────────────────────────
# These fine-tune completion for specific commands beyond what's in .zshrc

# nvim: complete files with bat preview
zstyle ':fzf-tab:complete:nvim:*' \
  fzf-preview 'bat --color=always --style=numbers --line-range=:60 $realpath 2>/dev/null'

# pnpm run: complete script names from package.json
zstyle ':completion:*:pnpm-run:*' command-list always

# git: show remote branch names when completing git push/pull
zstyle ':completion:*:git-checkout:*'  sort false
zstyle ':completion:*:git-switch:*'    sort false

# ssh: complete hostnames from ssh config
[[ -f "$HOME/.ssh/config" ]] && \
  zstyle ':completion:*:ssh:*' hosts \
    $(grep '^Host' "$HOME/.ssh/config" | grep -v '\*' | awk '{print $2}')
