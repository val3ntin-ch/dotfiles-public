function pnscript -d "fzf pick package.json script → pnpm run"
    if not test -f package.json
        echo "no package.json in cwd"
        return 1
    end
    set -l script (python3 -c "
import sys, json
scripts = json.load(open('package.json')).get('scripts', {})
for k, v in scripts.items():
    print(k + '\t' + v)
" | fzf --tabstop=30 \
         --prompt='pnpm run ❯ ' \
         --preview='echo {2..}' \
         --preview-window='down:3:wrap' \
    | awk '{print $1}')
    test -n "$script"; and pnpm run $script
end
