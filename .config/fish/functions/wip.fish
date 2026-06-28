function wip -d "Quick WIP commit (timestamped, skips CI)"
    git add -A
    git commit -m "wip: "(date '+%Y-%m-%d %H:%M')" [skip ci]"
end
