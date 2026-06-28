function up -d "Go up N directories (default 1)"
    set -l n 1
    if test (count $argv) -gt 0
        set n $argv[1]
    end
    set -l path ""
    for i in (seq $n)
        set path "../$path"
    end
    cd $path
end
