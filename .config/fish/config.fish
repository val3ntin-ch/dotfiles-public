# ~/.config/fish/config.fish

# Silence greeting
set -g fish_greeting ""

# Set up fzf key bindings
fzf --fish | source

# Optional: local private overrides
set -l LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
test -f $LOCAL_CONFIG; and source $LOCAL_CONFIG

