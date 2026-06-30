# Press Enter on an empty prompt:
#   • inside a git repo → git status + recent log
#   • elsewhere         → eza -la

_magic_enter() {
  if [[ -n "$BUFFER" ]]; then
    zle accept-line
    return
  fi
  echo
  if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    git status -sb && echo && git log --oneline -5
  else
    eza --icons=always --group-directories-first --color=always -la --git
  fi
  echo
  zle reset-prompt
}
zle -N _magic_enter

# Register after zsh-vi-mode initialises (it resets all bindings on init)
zvm_after_init_commands+=('bindkey "^M" _magic_enter')
