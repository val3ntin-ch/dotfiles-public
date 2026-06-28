function prco -d "Checkout a GitHub PR by number (requires gh CLI)"
    if test (count $argv) -eq 0
        echo "usage: prco <pr-number>"
        return 1
    end
    gh pr checkout $argv[1]
end
