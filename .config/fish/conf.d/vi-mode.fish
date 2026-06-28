if status is-interactive
    # VI key bindings
    set -g fish_key_bindings fish_vi_key_bindings

    # Cursor shapes per mode
    set -g fish_cursor_default     block
    set -g fish_cursor_insert      line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual      block

    # Fast escape (ms)
    set -g fish_escape_delay_ms 10
end
