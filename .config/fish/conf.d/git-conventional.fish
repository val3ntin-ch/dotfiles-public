# ~/.config/fish/conf.d/git-conventional.fish
# Conventional commit abbreviations — expand in-place so you can complete the message
if status is-interactive
    abbr -a gcfeat     'git commit -m "feat: "'
    abbr -a gcfix      'git commit -m "fix: "'
    abbr -a gcdocs     'git commit -m "docs: "'
    abbr -a gcrefactor 'git commit -m "refactor: "'
    abbr -a gcperf     'git commit -m "perf: "'
    abbr -a gctest     'git commit -m "test: "'
    abbr -a gcchore    'git commit -m "chore: "'
    abbr -a gcbuild    'git commit -m "build: "'
    abbr -a gcci       'git commit -m "ci: "'
    abbr -a gcstyle    'git commit -m "style: "'
    abbr -a gcrev      'git revert'
end
