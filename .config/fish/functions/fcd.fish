function fcd -d "Fuzzy cd: pick directory with fzf"
    set -l root (count $argv -gt 0; and echo $argv[1]; or echo ".")
    set -l dir (fd --type d --hidden --follow \
        --exclude .git --exclude node_modules --exclude .cache \
        $root 2>/dev/null \
        | fzf \
            --preview='eza --icons=always --tree --level=2 --color=always {}' \
            --preview-window='right:50%' \
            --prompt='cd ❯ ')
    test -n "$dir"; and cd $dir
end
