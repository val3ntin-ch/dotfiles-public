function glf -d "Interactive git log browser (Enter to view full diff)"
    git log --oneline --color=always --decorate $argv \
        | fzf --ansi --no-sort \
              --preview='git show --color=always --stat {1}' \
              --preview-window='right:55%' \
              --bind='enter:execute(git show --color=always {1} | less -R)' \
              --prompt='log ❯ '
end
