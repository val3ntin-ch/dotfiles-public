function stow_pkg -d "Stow a single dotfiles package"
    if test (count $argv) -eq 0
        echo "usage: stow_pkg <package>"
        return 1
    end
    set -l pkg $argv[1]
    set -l dotdir (set -q DOTFILES_DIR; and echo $DOTFILES_DIR; or echo $HOME/.dotfiles)
    stow --dir=$dotdir --target=$HOME --restow --no-folding ".config/$pkg"
    and echo "✓ stowed: $pkg"
end
