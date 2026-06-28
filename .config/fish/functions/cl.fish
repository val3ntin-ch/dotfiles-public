function cl -d "cd then eza"
    cd (count $argv -gt 0; and echo $argv[1]; or echo .)
    and eza --icons=always --group-directories-first --color=always -la --git --time-style=relative 2>/dev/null
    or ls -la
end
