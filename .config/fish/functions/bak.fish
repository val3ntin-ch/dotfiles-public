function bak -d "Backup a file with timestamp"
    if test (count $argv) -eq 0
        echo "usage: bak <file>"
        return 1
    end
    cp -v $argv[1] "$argv[1].bak."(date +%Y%m%d-%H%M%S)
end
