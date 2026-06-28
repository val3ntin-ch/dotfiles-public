function gdf -d "Fuzzy pick a changed file to diff"
    set -l file (git status --short \
        | fzf --ansi \
              --preview='git diff --color=always -- {2}' \
              --preview-window='right:60%' \
              --prompt='diff ❯ ' \
        | awk '{print $2}')
    test -n "$file"; and git diff $file
end
