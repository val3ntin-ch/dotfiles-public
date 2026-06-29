# ~/.zshenv
# The ONLY zsh file that lives at ~/
# ZSH loads this first, for every shell (scripts, SSH, interactive, login)

export ZDOTDIR="$HOME/.config/zsh"

# XDG base dirs set here so they're available before ZDOTDIR is resolved
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ANTIDOTE_HOME="$HOME/.local/share/antidote"
