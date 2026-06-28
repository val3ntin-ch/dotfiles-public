function gsf -d "Fuzzy git branch switcher with commit preview"
    set -l branch (git branch --all --color=always 2>/dev/null \
        | grep -v HEAD \
        | sed 's|remotes/[^/]*/||' \
        | sort -u \
        | fzf --ansi \
              --preview='git log --oneline --color=always -15 {1} 2>/dev/null' \
              --preview-window='right:50%' \
              --prompt='branch ❯ ' \
        | string trim \
        | sed 's|remotes/[^/]*/||')
    test -n "$branch"; and git switch $branch
end
