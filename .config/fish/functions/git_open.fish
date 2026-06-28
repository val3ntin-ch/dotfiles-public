function git_open -d "Open current repo on GitHub in browser"
    set -l url (git remote get-url origin 2>/dev/null)
    if test -z "$url"
        echo "not a git repo or no origin"
        return 1
    end
    set url (string replace 'git@github.com:' 'https://github.com/' $url)
    set url (string replace -r '\.git$' '' $url)
    if test (uname) = Darwin
        open $url
    else
        xdg-open $url
    end
end
