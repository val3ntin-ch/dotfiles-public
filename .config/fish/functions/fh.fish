function fh -d "Fuzzy history search — puts selection on command line"
    set -l cmd (builtin history \
        | fzf --no-sort --tac \
              --preview='echo {}' \
              --preview-window='down:3:wrap' \
              --prompt='history ❯ ')
    if test -n "$cmd"
        commandline $cmd
    end
end
