# ~/.config/fish/conf.d/prompt-starship.fish
if status is-interactive
    # Prefer default config location: ~/.config/starship.toml
    # If you keep it elsewhere, uncomment and set the path:
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml

    starship init fish | source
end
