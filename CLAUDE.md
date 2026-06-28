# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles managed with GNU Stow. Each subdirectory of `.config/` is a stow package that gets symlinked into `$HOME/.config/` on the target machine.

## Stow — how to apply changes

Run from inside `~/.dotfiles`:

```bash
cd ~/.dotfiles
stow --target="$HOME" --restow .
```

This stows the entire dotfiles tree to `$HOME`. Stow uses directory folding by default — tool config dirs (fish, tmux, yazi, etc.) become symlinks rather than individual file links. This is intentional: it's simpler and works correctly.

`.stow-local-ignore` at the root excludes `CLAUDE.md`, `README.md`, `.git`, etc.

After fresh clone on a new machine:
1. `cd ~/.dotfiles && stow --target="$HOME" --restow .`
2. `fisher install` (reads fish_plugins, reinstalls all fish plugins)
3. Install tmux plugins: open tmux, press `<prefix> I`
4. `ya pkg install` (installs yazi plugins from package.toml)
5. Antidote auto-compiles zsh plugins on first shell start

## Reloading configs without restarting

```bash
# Fish
exec fish          # alias: reload

# Zsh
exec zsh           # alias: reload

# Tmux (prefix is Ctrl+t, not Ctrl+b)
<prefix> r         # source-file reload
# or:
tmux source-file ~/.config/tmux/tmux.conf
```

## Validating syntax before sourcing

```bash
fish --no-execute ~/.config/fish/conf.d/aliases.fish   # fish syntax check
zsh -n ~/.config/zsh/.zshrc                             # zsh syntax check
```

## Plugin managers

**Fish — Fisher**
```bash
fisher install author/plugin    # add (also updates fish_plugins)
fisher update                   # update all
fisher remove author/plugin     # remove
```
Plugin list: `.config/fish/fish_plugins`. Fisher auto-sources everything into `conf.d/` and `functions/`.

**Zsh — Antidote**
Plugin list: `.config/zsh/.zsh_plugins.txt`
Antidote auto-recompiles `.zsh_plugins.zsh` on the next shell start when `.zsh_plugins.txt` is newer. To force rebuild:
```bash
antidote bundle < ~/.config/zsh/.zsh_plugins.txt > ~/.config/zsh/.zsh_plugins.zsh
```

**Tmux — TPM**
```
<prefix> I    # install plugins
<prefix> U    # update plugins
<prefix> alt+u  # remove unused
```
TPM auto-bootstraps on first run (clones itself if missing). Plugins live in `.config/tmux/plugins/` — these are **committed** to the repo (not gitignored).

## Architecture

### Two shells, intentionally aligned

Fish and zsh configs mirror each other. Both use the same tools (eza, bat, fzf, zoxide, delta, starship, rg, fd) with the same flags and Catppuccin Mocha theming. When adding an alias or function, add it to both shells.

### Config structure pattern

**Fish** splits by concern into `conf.d/` files (loaded alphabetically before `config.fish`):
- `env.fish` — all `set -gx` environment variables
- `path.fish` — PATH additions via `fish_add_path`
- `aliases.fish` — tool aliases and shell shortcuts
- `tools-eza.fish` — eza/ls aliases
- `git-conventional.fish` — conventional commit abbrs
- `git.fish` — initializes jhillyerd/plugin-git abbreviations
- `prompt-starship.fish`, `zoxide.fish`, `tmux.fish`, `fzf.fish` — one-tool-per-file integrations

Functions are one file per function in `functions/` — fish autoloads them lazily.

**Zsh** splits by concern into `conf.d/` files (sourced at end of `.zshrc`):
- `.zshenv` — env vars and PATH (runs for ALL shells including scripts)
- `.zprofile` — login-only: `brew shellenv`, nvm, pyenv, rbenv
- `.zshrc` — interactive: completions → antidote → history → setopts → vi-mode → plugins config → tools init → sources conf.d/
- `conf.d/aliases.zsh` — all aliases
- `conf.d/functions.zsh` — all functions
- `conf.d/git.zsh` — delta, git log formats, gsync/gstat functions
- `conf.d/completions.zsh` — cached tool completions (gh, docker, kubectl, pnpm, etc.)

**Shared across shells:**
- `starship/starship.toml` — single prompt config for both
- `tmux/` — single tmux config used by both via `$fish_tmux_config` / `tsrc` alias

### Catppuccin Mocha — layered theming

Applied at every layer: Ghostty terminal → fish `fish_color_*` vars / zsh F-Sy-H `FAST_HIGHLIGHT_STYLES` → Starship palette → bat `BAT_THEME` → fzf `FZF_DEFAULT_OPTS` colors → eza `EZA_COLORS` → ls `LS_COLORS` via vivid → delta `DELTA_FEATURES` → tmux catppuccin plugin.

`vivid` generates `LS_COLORS` at shell start (`vivid generate catppuccin-mocha`). If vivid is absent, the variable is simply unset — ls still works, just without custom colors.

### Tmux key differences from defaults

- Prefix: `Ctrl+t` (not `Ctrl+b`)
- Splits: `<prefix> v` (horizontal), `<prefix> g` (vertical)
- Pane nav: `Ctrl+h/j/k/l` (no prefix, via vim-tmux-navigator)
- Pane resize: `Ctrl+Shift+h/j/k/l` (no prefix)
- Session picker: `<prefix> o` (sesh — Go binary, zoxide-integrated, fzf popup)
- Sessions persist via tmux-resurrect (saved to `.config/tmux/resurrect/`)

### Zsh-specific features not in fish

- `fzf-tab`: every Tab keypress opens fzf with per-command previews (cd shows eza tree, git shows diffs, kill shows process info, etc.)
- `zsh-vi-mode`: full vi editing with text objects, cursor shape changes, `jk` escape, system clipboard yank/paste
- `magic-enter`: empty Enter in a git repo → `git status -sb && git log --oneline -5`; in plain dir → `eza -la`
- `you-should-use`: reminds you after running a command that has an alias defined
- `zsh-autopair`: auto-closes `()[]{}""''`
- Cached completions in `conf.d/completions.zsh`: generates and caches `gh`/`docker`/`kubectl`/`helm`/`pnpm`/`rustup`/`starship`/`fnm` completions, regenerating only when the binary changes

### Fish-specific features not in zsh

- `jhillyerd/plugin-git`: ~150 git **abbreviations** (expand on Space, editable before Enter) — zsh uses static aliases
- `gbage`: list branches by age
- `gbda`: delete merged branches including squash-merged (zsh only has `gbrclean` for regular merges)
- `tds`: create tmux session named after current directory (path-hashed for uniqueness)
- Git flow, bisect, svn, GitLab MR abbreviations

## Tools expected on the machine

`nvim`, `eza`, `bat`, `fd`, `rg`, `fzf`, `zoxide`, `delta` (`git-delta`), `vivid`, `starship`, `tmux`, `sesh`, `fnm`, `gh`, `stow`, `pnpm`

`sesh` installs from a custom tap: `brew install joshmedeski/sesh/sesh`
