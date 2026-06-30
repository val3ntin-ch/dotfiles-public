# Auto-source .env when entering a directory.
# Asks confirmation the first time per directory; remembers the answer.
# Persistent allow/deny lists stored in $XDG_CACHE_HOME/zsh/ (proper XDG paths).

_dotenv_hook() {
  local dotenv="$PWD/.env"
  [[ -f "$dotenv" ]] || return

  local allowed_list="$XDG_CACHE_HOME/zsh/dotenv-allowed.list"
  local disallowed_list="$XDG_CACHE_HOME/zsh/dotenv-disallowed.list"
  local dirpath="${PWD:A}"

  grep -qFx "$dirpath" "$disallowed_list" 2>/dev/null && return

  if grep -qFx "$dirpath" "$allowed_list" 2>/dev/null; then
    set -a; source "$dotenv"; set +a
    return
  fi

  local reply
  echo -n "dotenv: found .env — source it? ([y]es/[N]o/[a]lways/n[e]ver) "
  read -k 1 reply
  echo
  case "$reply" in
    [yY]) set -a; source "$dotenv"; set +a ;;
    [aA]) echo "$dirpath" >> "$allowed_list"; set -a; source "$dotenv"; set +a ;;
    [eE]) echo "$dirpath" >> "$disallowed_list" ;;
  esac
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _dotenv_hook
