function json -d "Pretty-print JSON (file or stdin) via bat"
    if test (count $argv) -gt 0
        python3 -m json.tool $argv[1] | bat --language=json --paging=never
    else
        python3 -m json.tool | bat --language=json --paging=never
    end
end
