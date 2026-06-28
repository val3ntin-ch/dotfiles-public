function fe -d "Fuzzy find file, open in \$EDITOR"
    set -l root (count $argv -gt 0; and echo $argv[1]; or echo ".")
    set -l file (fd --type f --hidden --follow \
        --exclude .git --exclude node_modules \
        $root 2>/dev/null \
        | fzf \
            --preview='bat --color=always --style=numbers,changes --line-range=:80 {}' \
            --preview-window='right:55%' \
            --prompt='edit ❯ ')
    test -n "$file"; and $EDITOR $file
end
