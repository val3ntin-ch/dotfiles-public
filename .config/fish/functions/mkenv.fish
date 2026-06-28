function mkenv -d "Create .env from .env.example"
    set -l src (count $argv -gt 0; and echo $argv[1]; or echo .env.example)
    set -l dst (count $argv -gt 1; and echo $argv[2]; or echo .env)
    if not test -f $src
        echo "no $src found"
        return 1
    end
    if test -f $dst
        echo "$dst already exists, not overwriting"
        return 1
    end
    cp $src $dst; and echo "created $dst from $src"
end
