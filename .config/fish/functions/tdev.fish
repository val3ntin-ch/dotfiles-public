function tdev -d "Create structured tmux dev session: editor + dev split"
    set -l name (count $argv -gt 0; and echo $argv[1]; or basename $PWD)
    set -l root (count $argv -gt 1; and echo $argv[2]; or echo $PWD)

    if not tmux has-session -t $name 2>/dev/null
        tmux new-session -d -s $name -c $root

        # Window 1: editor
        tmux rename-window -t "$name:1" editor
        tmux send-keys -t "$name:editor" 'nvim .' Enter

        # Window 2: dev (horizontal split)
        tmux new-window -t $name -n dev -c $root
        tmux split-window -t "$name:dev" -h -c $root
        tmux select-pane -t "$name:dev.left"
    end

    if test -n "$TMUX"
        tmux switch-client -t $name
    else
        tmux attach-session -t $name
    end
end
