function gsync -d "Rebase current branch on origin/main (or master)"
    set -l main_branch (__git.default_branch)
    set -l current_branch (__git.current_branch)

    if test "$current_branch" = "$main_branch"
        git pull --rebase origin $main_branch
        return
    end

    echo "Syncing $current_branch with $main_branch..."
    git fetch origin $main_branch
    and git rebase origin/$main_branch
    and echo "✓ rebased $current_branch onto origin/$main_branch"
end
