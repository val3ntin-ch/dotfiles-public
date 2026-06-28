function rgv -d "ripgrep → fzf → open nvim at exact line"
    if test (count $argv) -eq 0
        echo "usage: rgv <pattern> [path]"
        return 1
    end
    set -l result (command rg --line-number --no-heading --color=always --smart-case $argv \
        | fzf --ansi \
              --delimiter=: \
              --preview='bat --color=always --style=numbers --highlight-line={2} {1}' \
              --preview-window='right:55%,+{2}-5' \
              --prompt='rg ❯ ')
    test -z "$result"; and return
    set -l file (string split : $result)[1]
    set -l line  (string split : $result)[2]
    nvim +"$line" "$file"
end
