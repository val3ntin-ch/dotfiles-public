function stow_all -d "Restow every package in ~/.dotfiles/.config/"
    set -l dotdir (set -q DOTFILES_DIR; and echo $DOTFILES_DIR; or echo $HOME/.dotfiles)
    if not test -d $dotdir/.config
        echo "no .config dir in $dotdir"
        return 1
    end

    # tool-conditional packages: only stow if binary exists
    set -l cond_pkgs alacritty kitty wezterm
    set -l cond_bins alacritty kitty wezterm

    set -l count 0
    set -l skipped 0

    for pkg_path in $dotdir/.config/*/
        set -l pkg (basename $pkg_path)

        set -l skip 0
        for i in (seq (count $cond_pkgs))
            if test $pkg = $cond_pkgs[$i]; and not command -q $cond_bins[$i]
                echo "  skip  $pkg  ($cond_bins[$i] not found)"
                set skipped (math $skipped + 1)
                set skip 1
                break
            end
        end

        if test $skip -eq 0
            stow_pkg $pkg; and set count (math $count + 1)
        end
    end

    echo ""
    echo "stowed $count packages, skipped $skipped"
end
