# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## 5. Current Setup State

**Platform:** macOS only. Linux support is planned but not yet implemented.

**Package manager:** Homebrew. All tools installed via `brew install` / `brew install --cask`.

**Bootstrap:** `install.sh` at the repo root handles everything:

```
clone repo → run install.sh → open new terminal → done
```

Steps inside `install.sh`:
1. Install Homebrew (if missing) + `brew update`
2. Core tools: fish, zsh, starship, antidote, neovim, git, gh, lazygit, git-delta, stow, tmux, vivid, ouch, bat, eza, fnm, pnpm, go, pyenv, rbenv
3. Yazi + deps: yazi, ffmpeg-full, sevenzip, jq, poppler, fd, ripgrep, fzf, zoxide, resvg, imagemagick-full → `brew link ffmpeg-full imagemagick-full -f --overwrite`
4. Sesh: `brew install joshmedeski/sesh/sesh`
5. Casks: ghostty, font-jetbrains-mono-nerd-font, font-symbols-only-nerd-font
6. Stow dotfiles to `$HOME`
7. `chsh` to brew zsh
8. Fish plugins via Fisher (bootstrapped via curl, reads `fish_plugins`)
9. Tmux plugins via TPM (headless tmux session triggers auto-bootstrap)
10. Node LTS via fnm

**Not handled by install.sh:** yazi plugins (`ya pkg install`) — optional, run manually.

**Stow ignore:** `.stow-local-ignore` (filename required by GNU Stow, cannot be renamed) excludes: `*.md`, `CLAUDE.md`, `.git`, `.gitignore`, `.claude`, `.stow-local-ignore`, `install.sh`.
