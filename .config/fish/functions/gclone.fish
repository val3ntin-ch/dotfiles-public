function gclone -d "git clone then cd into repo (supports user/repo shorthand)"
    if test (count $argv) -eq 0
        echo "usage: gclone <url|user/repo> [dir]"
        return 1
    end
    set -l url $argv[1]
    if not string match -qr '://' $url; and not string match -qr '^git@' $url
        set url "https://github.com/$url"
    end
    set -l dir (count $argv -gt 1; and echo $argv[2]; or basename (string replace -r '\.git$' '' $url))
    git clone $url $dir; and cd $dir
end
