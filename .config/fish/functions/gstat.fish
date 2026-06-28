function gstat -d "Show all branches ahead/behind origin/main"
    set -l main_branch (__git.default_branch)
    for branch in (git for-each-ref --format='%(refname:short)' refs/heads)
        set -l ahead  (git rev-list --count "origin/$main_branch..$branch" 2>/dev/null; or echo '?')
        set -l behind (git rev-list --count "$branch..origin/$main_branch" 2>/dev/null; or echo '?')
        printf "  %-30s  ahead: %s  behind: %s\n" $branch $ahead $behind
    end
end
