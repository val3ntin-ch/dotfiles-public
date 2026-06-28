function gaf -d "Fuzzy interactive git add with diff preview"
    set -l files (git status --short 2>/dev/null \
        | fzf --ansi \
              --multi \
              --preview='git diff --color=always -- {2} 2>/dev/null | head -60' \
              --preview-window='right:55%' \
              --prompt='stage ❯ ' \
        | awk '{print $2}')
    if test -n "$files"
        echo $files | xargs git add
        git status -sb
    end
end
