function fkill -d "Fuzzy kill process (optional signal, default -9)"
    set -l signal -9
    if test (count $argv) -gt 0
        set signal $argv[1]
    end
    set -l pids (ps aux \
        | fzf --header-lines=1 \
              --multi \
              --preview='echo {}' \
              --preview-window='down:3:wrap' \
              --prompt="kill ($signal) ❯ " \
        | awk '{print $2}')
    if test -n "$pids"
        echo $pids | xargs kill $signal
        echo "killed: $pids"
    end
end
