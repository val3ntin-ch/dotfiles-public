# ~/.config/fish/conf.d/tools-fzf.fish
if status is-interactive
    # Preview command used by fzf.fish for file previews (requires bat)
    set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"

    # Use modern bindings (0) instead of legacy ones
    set -g FZF_LEGACY_KEYBINDINGS 0
end
