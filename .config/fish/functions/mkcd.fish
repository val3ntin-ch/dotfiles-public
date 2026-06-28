function mkcd -d "mkdir -p then cd into it"
    if test (count $argv) -eq 0
        echo "usage: mkcd <path>"
        return 1
    end
    mkdir -p $argv[1]; and cd $argv[1]
end
