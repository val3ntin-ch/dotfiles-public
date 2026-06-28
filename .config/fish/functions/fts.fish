function fts -d "Fuzzy tmux session switcher"
    set -l session (tmux list-sessions -F '#{session_name}: #{session_windows} windows (#{window_name})' 2>/dev/null \
        | fzf --prompt='tmux ❯ ' \
              --preview='tmux list-windows -t {1}' \
              --preview-window='down:4:wrap' \
        | cut -d: -f1)
    test -n "$session"; and tmux switch-client -t $session
end
