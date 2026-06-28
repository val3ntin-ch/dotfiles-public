# ~/.config/fish/conf.d/tools-eza.fish
if status is-interactive
    if type -q eza
        alias ls  "eza --group-directories-first --icons"
        alias ll  "eza -l -g --icons"
        alias la  "eza -a --icons"
        alias lla "eza -la -g --icons"
        alias llt "eza -la -g --icons --tree --level=2"
    else
        # macOS BSD ls fallback
        alias ls  "ls -p -G"
        alias la  "ls -A"
        alias ll  "ls -l"
        alias lla "ls -lA"
    end
end
