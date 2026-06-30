# $ZDOTDIR/conf.d/git.zsh
# ══════════════════════════════════════════════════════════════════════════════
# Git environment config — things that configure git's BEHAVIOUR in the shell,
# not aliases (those are in aliases.zsh).
#
# why a separate git.zsh?
#
# Aliases go in aliases.zsh. But git also has shell-level integrations:
#   • Prompt info (branch, dirty state) — handled by Starship
#   • Pretty log formats stored as shell variables
#   • Global git settings that apply to all repos
#   • Helper functions too complex for aliases
# ══════════════════════════════════════════════════════════════════════════════

# ── delta (better git diff viewer) ────────────────────────────────────────
#
# what is delta?
#
# `git diff` by default shows diffs in a plain, hard-to-read format.
# `delta` is a diff viewer that adds:
#   • Syntax highlighting (same themes as bat)
#   • Line numbers in both old and new version
#   • Side-by-side view (--side-by-side flag)
#   • Word-level diff highlighting
#   • Hyperlinks to GitHub/GitLab for blame/commit references
#
# It integrates with git as a pager (GIT_PAGER) — git automatically pipes
# `diff`, `log -p`, `show`, etc. through delta.
#
# The theme matches Catppuccin Mocha via ~/.gitconfig or env var below.
#
if command -v delta &>/dev/null; then
  export GIT_PAGER="delta"
  # delta config (can also go in ~/.gitconfig [delta] section)
  export DELTA_FEATURES="catppuccin-mocha"   # requires catppuccin/delta theme in gitconfig
fi

# ── Pretty log formats ─────────────────────────────────────────────────────
#
# git log --format uses placeholders:
#   %h  = short hash       %H  = full hash
#   %s  = subject (title)  %b  = body
#   %an = author name      %ae = author email
#   %ar = relative date    %ai = absolute date ISO
#   %d  = decorations (branch/tag labels)
#   %C(color) = start color  %Creset = reset color
#
# We store these as shell variables so we can use them in aliases/functions
# without repeating the whole format string.

# Compact: hash + decorations + subject + author + relative date
GIT_LOG_FORMAT="%C(#89b4fa)%h%C(reset) %C(#6c7086)%d%C(reset) %s %C(#9399b2)%an %C(#585b70)%ar%C(reset)"

# Full: above + body + stats
GIT_LOG_FORMAT_FULL="%C(#89b4fa)%H%C(reset)%n%C(#cba6f7)Author:%C(reset) %an <%ae>%n%C(#cba6f7)Date:%C(reset)   %ai (%ar)%n%C(#cba6f7)%d%C(reset)%n%n%s%n%n%b"

export GIT_LOG_FORMAT GIT_LOG_FORMAT_FULL

# ── Conventional commit helper ─────────────────────────────────────────────
#
# Conventional Commits is a specification for commit messages:
#   type(scope): description
#   feat(auth): add OAuth2 login
#   fix(api): handle null response from endpoint
#   chore(deps): bump react-native to 0.74
#
# Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert
# Using this format enables automatic CHANGELOG generation and semantic versioning.
#
# These aliases make it fast to write conventional commits.
# They prepend the type and open the commit message editor.

alias gcfeat='git commit -m "feat: "'           # → feat: <your message>
alias gcfix='git commit -m "fix: "'
alias gcdocs='git commit -m "docs: "'
alias gcrefactor='git commit -m "refactor: "'
alias gcperf='git commit -m "perf: "'
alias gctest='git commit -m "test: "'
alias gcchore='git commit -m "chore: "'
alias gcbuild='git commit -m "build: "'
alias gcci='git commit -m "ci: "'
alias gcrevert='git revert'

# ── Git branch name helpers ────────────────────────────────────────────────

# Current branch name (used in other aliases/functions)
git-branch-current() {
  git branch --show-current 2>/dev/null
}

# Main branch name (handles both `main` and `master`)
git-main-branch() {
  local main
  main=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  if [[ -z "$main" ]]; then
    # Fallback: check which of main/master exists
    if git show-ref --verify --quiet refs/heads/main; then
      main=main
    elif git show-ref --verify --quiet refs/heads/master; then
      main=master
    else
      main=main  # assume
    fi
  fi
  echo "$main"
}

# ── Sync with main ─────────────────────────────────────────────────────────
# gsync: update main, rebase current branch on top of it
# This is the cleanest way to stay current without messy merge commits.
gsync() {
  local main_branch current_branch
  main_branch=$(git-main-branch)
  current_branch=$(git-branch-current)

  if [[ "$current_branch" == "$main_branch" ]]; then
    git pull --rebase origin "$main_branch"
    return
  fi

  echo "Syncing $current_branch with $main_branch..."
  git fetch origin "$main_branch" \
    && git rebase "origin/$main_branch" \
    && echo "✓ rebased $current_branch onto origin/$main_branch"
}

# ── Branch summary ────────────────────────────────────────────────────────
# gstat: show all branches with ahead/behind counts vs origin/main
gstat() {
  local main_branch
  main_branch=$(git-main-branch)
  git for-each-ref --format='%(refname:short)' refs/heads \
    | while read branch; do
        local ahead behind
        ahead=$(git rev-list --count "origin/$main_branch..$branch" 2>/dev/null || echo '?')
        behind=$(git rev-list --count "$branch..origin/$main_branch" 2>/dev/null || echo '?')
        printf "  %-30s  ahead: %s  behind: %s\n" "$branch" "$ahead" "$behind"
      done
}
