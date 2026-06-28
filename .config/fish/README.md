# ~/.config/fish — Fish Shell Configuration

## FEYNMAN — what is this directory and why does it exist?

Fish has a strict load order. Every time you open a terminal (or a new tmux
pane, or run `exec fish`) Fish loads files in this sequence:

```
~/.config/fish/config.fish          → always, every shell
~/.config/fish/conf.d/*.fish        → always, alphabetical order, before config.fish
~/.config/fish/functions/*.fish     → autoloaded on first call (lazy)
~/.config/fish/completions/*.fish   → autoloaded when tab-completing
```

**Key difference from ZSH**: Fish has no `.profile` / `.zshenv` / `.zshrc`
split. There is no "login shell vs interactive shell" distinction that matters
in practice. `conf.d/` files run for every shell. Use `status is-interactive`
to guard anything that should only run in a terminal (not scripts).

**Key difference from ZSH**: Functions are autoloaded from `functions/`.
You never need to `source` them. Drop a file `foo.fish` in `functions/` and
`foo` is available immediately in every shell, lazily loaded on first call.

---

## § 1  Plugin Manager — Fisher

```
fish_plugins   ← the plugin list (like .zsh_plugins.txt in antidote)
```

Fisher is the package manager. It reads `fish_plugins`, clones repos into
`~/.local/share/fisher`, and generates function/conf.d files.

FEYNMAN — why Fisher over others (Oh-My-Fish, etc)?
- Plugin list is a plain text file → easy to read, diff, review in git
- `fisher install`/`fisher update`/`fisher remove` — simple CLI
- Minimal: no framework magic, just sources files
- Active maintenance as of 2026

### Installed plugins

| Plugin | What it does |
|--------|-------------|
| `jorgebucaran/fisher` | Fisher itself — the package manager |
| `patrickf1/fzf.fish` | fzf key bindings: `Ctrl-R` history, `Ctrl-T` files, `Ctrl-Alt-F` dirs, `Alt-C` cd |
| `kidonng/zoxide.fish` | zoxide integration: `z`, `zi` — frecency-based directory jumping |
| `jhillyerd/plugin-git` | ~150 git abbreviations (expand in-place on Space) |
| `catppuccin/fish` | Sets `fish_color_*` variables to Catppuccin Mocha palette |
| `budimanjojo/tmux.fish` | tmux wrapper: auto-connect, TERM fixing, `ta`/`ts`/`tl`/`tksv` etc. |

---

## § 2  conf.d/ — Startup Config Files

Files load alphabetically. All run before `config.fish`.

### `conf.d/env.fish` — Environment Variables

FEYNMAN — why a separate env file?

Fish has no `.zshenv` equivalent for scripts. But `conf.d/` files run for
every shell including non-interactive ones (when called as a script interpreter).
Putting environment variables here makes them available everywhere.

| Variable | Value | Why |
|----------|-------|-----|
| `XDG_CONFIG_HOME` | `~/.config` | XDG spec — keeps home dir clean |
| `XDG_CACHE_HOME` | `~/.cache` | XDG spec |
| `XDG_DATA_HOME` | `~/.local/share` | XDG spec |
| `XDG_STATE_HOME` | `~/.local/state` | XDG spec (history files, etc.) |
| `EDITOR` | `nvim` | default editor for all tools |
| `VISUAL` | `nvim` | GUI editor fallback (same as EDITOR) |
| `PAGER` | `less` | used by git, man, etc. |
| `LESS` | `-R -F -X --use-color -j4` | `-R` = colors, `-F` = auto-exit if fits, `-X` = don't clear |
| `LESSHISTFILE` | `~/.local/state/less/history` | XDG-compliant location |
| `MANPAGER` | `sh -c 'col -bx \| bat -l man -p'` | renders man pages with bat syntax highlighting |
| `MANROFFOPT` | `-c` | fixes color rendering in man via bat |
| `BAT_THEME` | `Catppuccin Mocha` | syntax highlighting theme for bat |
| `RIPGREP_CONFIG_PATH` | `~/.config/ripgrep/config` | persistent rg flags |
| `FZF_DEFAULT_OPTS` | Catppuccin Mocha colors + bindings | see below |
| `FZF_DEFAULT_COMMAND` | `fd --type f --hidden ...` | fd instead of find (respects .gitignore) |
| `FZF_CTRL_T_COMMAND` | same as DEFAULT_COMMAND | files picker |
| `FZF_ALT_C_COMMAND` | `fd --type d ...` | dirs picker |
| `FZF_CTRL_T_OPTS` | bat preview | file content on the right |
| `FZF_ALT_C_OPTS` | eza tree preview | directory tree on the right |
| `FZF_CTRL_R_OPTS` | echo preview | history entry preview |
| `LS_COLORS` | vivid catppuccin-mocha | 200+ file type colors for ls/eza |
| `EZA_COLORS` | Catppuccin Mocha columns | user/group/size/date/git/permissions colors |
| `EZA_ICONS_AUTO` | `1` | icons without needing `--icons` flag |
| `GREP_COLORS` | Catppuccin | match/filename/line number colors |
| `GCC_COLORS` | Catppuccin | compiler error/warning/note colors |
| `LANG` / `LC_ALL` | `en_US.UTF-8` | locale |
| `GIT_EDITOR` | `nvim` | editor for commit messages, rebases |
| `GIT_PAGER` | `delta` | syntax-highlighted diffs (if delta installed) |
| `DELTA_FEATURES` | `catppuccin-mocha` | delta color theme |
| `HOMEBREW_NO_ANALYTICS` | `1` | disable brew telemetry |
| `HOMEBREW_NO_AUTO_UPDATE` | `1` | update on your terms, not brew's |

**FZF Catppuccin Mocha palette:**
```
bg+:#313244   bg:#1e1e2e    spinner:#f5e0dc  hl:#f38ba8
fg:#cdd6f4    header:#f38ba8  info:#cba6f7   pointer:#f5e0dc
marker:#a6e3a1  fg+:#cdd6f4  prompt:#cba6f7  hl+:#f38ba8
border:#6c7086  label:#cdd6f4
```

**FZF bindings added:**
- `Ctrl-/` → toggle preview panel
- `Ctrl-U` → scroll preview half-page up
- `Ctrl-D` → scroll preview half-page down

---

### `conf.d/path.fish` — PATH and Runtime Paths

FEYNMAN — fish PATH is a list variable (`$PATH`), not a colon-separated string.
`fish_add_path -g` adds to the global universal PATH, deduplicating automatically.

| Path added | Why |
|-----------|-----|
| `~/bin`, `~/.local/bin` | personal scripts |
| `/opt/homebrew/bin` (macOS) | Homebrew (Apple Silicon) |
| `/usr/local/bin` (macOS) | Homebrew (Intel) |
| `$PNPM_HOME` (`~/.local/share/pnpm`) | pnpm global binaries |
| `$BUN_INSTALL/bin` (`~/.bun/bin`) | bun runtime |
| `$GOPATH/bin` (`~/.local/share/go/bin`) | Go binaries |
| `$ANDROID_HOME/emulator` | Android emulator (React Native) |
| `$ANDROID_HOME/platform-tools` | adb (React Native) |

**Environment variables set:**

| Variable | Value |
|----------|-------|
| `PNPM_HOME` | `~/.local/share/pnpm` |
| `BUN_INSTALL` | `~/.bun` |
| `GOPATH` | `~/.local/share/go` |
| `JAVA_HOME` | Zulu JDK 17 (if installed) — React Native Android |
| `ANDROID_HOME` | `~/Library/Android/sdk` (if installed) |
| `NVM_DIR` | `~/.nvm` (set for script compatibility) |

---

### `conf.d/aliases.fish` — Aliases

FEYNMAN — fish `alias foo 'bar'` creates a function named `foo` that calls `bar`.
It is NOT the same as zsh's `alias`. For tool-shadowing aliases (e.g. `rg` → `rg --flags`),
always prefix with `command` inside the alias body to avoid infinite recursion.

#### Editor
| Alias | Expands to |
|-------|-----------|
| `v`, `vi`, `vim`, `nv` | `nvim` |
| `svim` | `sudo -E nvim` (preserves your nvim config) |
| `inv` | `nvim (fzf -m --preview="bat --color=always {}")` |

#### bat (replaces cat)
| Alias | Expands to |
|-------|-----------|
| `cat` | `bat --paging=never --style=plain` |
| `catn` | `bat --paging=never --style=numbers,changes` |
| `catp` | `bat --style=numbers,changes,header` (with paging) |
| `batdiff` | `bat --diff` (show only changed lines) |

#### Navigation
| Alias | Expands to |
|-------|-----------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `.....` | `cd ../../../..` |

#### ripgrep
| Alias | Expands to |
|-------|-----------|
| `rg` | `rg --color=always --smart-case` |
| `rgi` | `rg --ignore-case` |
| `rgf` | `rg --files-with-matches` |
| `rgts` | `rg --type=ts` |
| `rgjs` | `rg --type=js` |

#### fd
| Alias | Expands to |
|-------|-----------|
| `fd` | `fd --color=always` |
| `fdf` | `fd --type f` |
| `fdd` | `fd --type d` |
| `fdh` | `fd --hidden` |

#### tmux
> `ta`, `tad`, `ts`, `tl`, `tksv`, `tkss`, `tds` provided by `budimanjojo/tmux.fish`

| Alias | Expands to |
|-------|-----------|
| `t` | `tmux` |
| `tn` | `tmux new-session -s` |
| `tns` | `tmux new-session` |
| `tw` | `tmux list-windows` |
| `tk` | `tmux kill-session -t` |
| `tka` | `tmux kill-server` |
| `trn` | `tmux rename-session` |
| `tpk` | `tmux kill-pane` |
| `tsrc` | `tmux source-file ~/.config/tmux/tmux.conf` |
| `T` | `tmux new-session -A -s main` (attach to "main" or create it) |

#### pnpm
| Alias | Expands to |
|-------|-----------|
| `pn` | `pnpm` |
| `pni` | `pnpm install` |
| `pna` | `pnpm add` |
| `pnad` | `pnpm add -D` |
| `pnr` | `pnpm run` |
| `pnd` | `pnpm dev` |
| `pnb` | `pnpm build` |
| `pnt` | `pnpm test` |
| `pntw` | `pnpm test --watch` |
| `pnl` | `pnpm lint` |
| `pnlf` | `pnpm lint --fix` |
| `pntc` | `pnpm typecheck` |
| `pnx` | `pnpm dlx` (like npx) |
| `pnup` | `pnpm update --interactive --latest` |
| `pnwhy` | `pnpm why` |
| `pnclean` | `rm -rf node_modules .turbo dist && pnpm install` |

#### React Native / Expo
| Alias | Expands to |
|-------|-----------|
| `rni` | `npx react-native run-ios` |
| `rna` | `npx react-native run-android` |
| `rnios` | `npx react-native run-ios --simulator="iPhone 15 Pro"` |
| `pods` | `cd ios && bundle exec pod install && cd ..` |
| `rnclean` | watchman + rm node_modules/Pods/builds + pnpm install |
| `expo` | `npx expo` |
| `expod` | `npx expo start` |
| `expob` | `npx expo build` |
| `expodc` | `npx expo start --clear` |

#### System utilities
| Alias | Expands to |
|-------|-----------|
| `reload` | `exec fish` (fresh shell, clean state) |
| `path` | `printf "%s\n" $PATH \| nl` |
| `ports` | `lsof -i -P -n \| grep LISTEN` |
| `myip` | curl api.ipify.org |
| `df` | `df -h` |
| `du` | `du -sh` |
| `dua` | `du -sh * \| sort -h` |
| `psa` | `ps aux` |
| `psg` | `ps aux \| grep` |
| `ping` | `ping -c 5` |

#### Dotfiles
| Alias | Expands to |
|-------|-----------|
| `dot` | `cd ~/.dotfiles` |
| `frc` | `nvim ~/.config/fish/config.fish` |
| `falias` | `nvim ~/.config/fish/conf.d/aliases.fish` |
| `fenv` | `nvim ~/.config/fish/conf.d/env.fish` |
| `fpath` | `nvim ~/.config/fish/conf.d/path.fish` |
| `ffn` | `nvim ~/.config/fish/functions` |

#### Clipboard (cross-platform)
| Alias | Platform |
|-------|---------|
| `copy` / `paste` | macOS → `pbcopy` / `pbpaste` |
| `copy` / `paste` | Wayland → `wl-copy` / `wl-paste` |
| `copy` / `paste` | X11 → `xclip -selection clipboard` |

#### macOS-specific
| Alias | Expands to |
|-------|-----------|
| `o` | `open` |
| `ql` | `qlmanage -p` (QuickLook from terminal) |
| `flushdns` | `dscacheutil -flushcache && killall -HUP mDNSResponder` |
| `showfiles` | show hidden files in Finder |
| `hidefiles` | hide hidden files in Finder |
| `cleanup` | `find . -type f -name "*.DS_Store" -delete` |
| `update` | `brew update && brew upgrade && brew autoremove && brew cleanup` |
| `brewdump` | `brew bundle dump --file=~/.dotfiles/Brewfile --force` |
| `awake` | `caffeinate -d` (keep mac awake) |

---

### `conf.d/aliases.fish` — eza (tools-eza.fish)

FEYNMAN — why eza instead of ls?
eza shows icons, git status per file, column headers, human sizes, symlink targets,
color-coded permissions. Configured via `EZA_COLORS` (Catppuccin) in env.fish.

| Alias | Expands to |
|-------|-----------|
| `ls` | `eza --group-directories-first --icons` |
| `ll` | `eza -l -g --icons` |
| `la` | `eza -a --icons` |
| `lla` | `eza -la -g --icons` |
| `llt` | `eza -la -g --icons --tree --level=2` |

---

### `conf.d/git.fish` — Git Plugin Init

Initializes `jhillyerd/plugin-git` abbreviations. See § 3 for the full list.

---

### `conf.d/git-conventional.fish` — Conventional Commit Abbreviations

FEYNMAN — Conventional Commits format: `type(scope): description`
Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert.
Using this format enables automatic CHANGELOG generation and semantic versioning.

These are **abbreviations** (not aliases) — they expand in-place on Space so you
can complete the commit message inline before pressing Enter.

| Abbr | Expands to |
|------|-----------|
| `gcfeat` | `git commit -m "feat: "` |
| `gcfix` | `git commit -m "fix: "` |
| `gcdocs` | `git commit -m "docs: "` |
| `gcrefactor` | `git commit -m "refactor: "` |
| `gcperf` | `git commit -m "perf: "` |
| `gctest` | `git commit -m "test: "` |
| `gcchore` | `git commit -m "chore: "` |
| `gcbuild` | `git commit -m "build: "` |
| `gcci` | `git commit -m "ci: "` |
| `gcstyle` | `git commit -m "style: "` |
| `gcrev` | `git revert` |

---

### `conf.d/fzf.fish` — fzf Bindings (patrickf1/fzf.fish)

FEYNMAN — fzf.fish intercepts key bindings and opens fzf with context-aware lists.

| Binding | Action |
|---------|--------|
| `Ctrl-R` | search shell history |
| `Ctrl-T` | search files, insert path at cursor |
| `Ctrl-Alt-F` | search files, insert path at cursor (alternative) |
| `Alt-C` | cd into fuzzy-picked directory |

Preview commands set in `tools-fzf.fish`:
- `FZF_PREVIEW_FILE_CMD` → `bat --style=numbers --color=always --line-range :500`

---

### `conf.d/prompt-starship.fish` — Starship Prompt

FEYNMAN — Starship is a cross-shell prompt written in Rust.
Config lives at `~/.config/starship/starship.toml` — shared between fish and zsh.
Your prompt looks **identical** in both shells.

Current format: `$directory$character` on left, `$all` on right.
Catppuccin Mocha palette defined in starship.toml via `[palettes.catppuccin_mocha]`.

---

### `conf.d/zoxide.fish` — Zoxide (kidonng/zoxide.fish)

FEYNMAN — zoxide tracks every directory you visit, weighted by frecency
(frequency + recency). It learns your habits.

| Command | What it does |
|---------|-------------|
| `z foo` | jump to most frecent dir matching "foo" |
| `z foo bar` | matching both "foo" and "bar" in path |
| `zi` | opens fzf to fuzzy-pick from history |

---

### `conf.d/tmux.fish` — Tmux Plugin (budimanjojo/tmux.fish)

FEYNMAN — wraps the `tmux` command to fix `$TERM`, auto-connect to existing
sessions, and provide directory-named session creation.

| Alias/function | What it does |
|----------------|-------------|
| `ta` | `tmux attach -t <session>` |
| `tad` | `tmux attach -d -t <session>` (detach others first) |
| `ts` | `tmux new-session -s <name>` |
| `tl` | `tmux list-sessions` |
| `tksv` | `tmux kill-server` |
| `tkss` | `tmux kill-session -t <name>` |
| `tds` | create/attach session named after current dir (path-hashed) |
| `tmuxconf` | open tmux config in `$EDITOR` |

---

## § 3  Git Abbreviations — jhillyerd/plugin-git

FEYNMAN — abbreviations differ from aliases: when you type `ga` and press Space,
it expands to `git add` **in the command line** — you can see and edit it before
running. Aliases run silently. Abbrs are better for git because git commands
often need additional arguments you want to see.

### Status
| Abbr | Expands to |
|------|-----------|
| `gsb` | `git status -sb` |
| `gss` | `git status -s` |
| `gst` | `git status` |
| `gsh` | `git show` |
| `gcount` | `git shortlog -sn` |

### Add / Stage
| Abbr | Expands to |
|------|-----------|
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gau` | `git add --update` |
| `gapa` | `git add --patch` |

### Commit
| Abbr | Expands to |
|------|-----------|
| `gc` | `git commit -v` |
| `gcm` | `git commit -m` |
| `gc!` | `git commit -v --amend` |
| `gcn!` | `git commit -v --no-edit --amend` |
| `gca` | `git commit -v -a` |
| `gca!` | `git commit -v -a --amend` |
| `gcfx` | `git commit --fixup` |
| `gcs` | `git commit -S` (GPG signed) |

### Branch
| Abbr | Expands to |
|------|-----------|
| `gb` | `git branch -vv` |
| `gba` | `git branch -a -v` |
| `gban` | `git branch -a -v --no-merged` |
| `gbd` | `git branch -d` |
| `gbD` | `git branch -D` |
| `ggsup` | `git branch --set-upstream-to=origin/<current>` |

### Checkout / Switch
| Abbr | Expands to |
|------|-----------|
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gcom` | `git checkout <main-branch>` |
| `gcod` | `git checkout develop` |
| `gsw` | `git switch` |
| `gswc` | `git switch --create` |

### Diff
| Abbr | Expands to |
|------|-----------|
| `gd` | `git diff` |
| `gdca` | `git diff --cached` |
| `gds` | `git diff --stat` |
| `gdw` | `git diff --word-diff` |
| `gdto` | `git difftool` |

### Log
| Abbr | Expands to |
|------|-----------|
| `glo` | `git log --oneline --decorate --color` |
| `glog` | `git log --oneline --decorate --color --graph` |
| `gloga` | `git log --oneline --decorate --color --graph --all` |
| `glg` | `git log --stat` |
| `glgg` | `git log --graph` |
| `gloo` | `git log --pretty=format:'%h %ad %an%d %s' --date=short` |

### Push / Pull
| Abbr | Expands to |
|------|-----------|
| `gp` | `git push` |
| `gp!` | `git push --force-with-lease` |
| `gpo` | `git push origin` |
| `gpo!` | `git push --force-with-lease origin` |
| `gpu` | `git push origin <current> --set-upstream` |
| `ggp` | `git push origin <current-branch>` |
| `ggp!` | `git push origin <current-branch> --force-with-lease` |
| `gl` | `git pull` |
| `glr` | `git pull --rebase` |
| `ggl` | `git pull origin <current-branch>` |
| `gup` | `git pull --rebase` |
| `gupa` | `git pull --rebase --autostash` |

### Fetch
| Abbr | Expands to |
|------|-----------|
| `gf` | `git fetch` |
| `gfa` | `git fetch --all --prune` |
| `gfo` | `git fetch origin` |
| `gfm` | `git fetch origin <main> --prune && git merge FETCH_HEAD` |

### Rebase
| Abbr | Expands to |
|------|-----------|
| `grb` | `git rebase` |
| `grbi` | `git rebase --interactive` |
| `grbm` | `git rebase <main-branch>` |
| `grbmi` | `git rebase <main-branch> --interactive` |
| `grbmia` | `git rebase <main-branch> --interactive --autosquash` |
| `grbc` | `git rebase --continue` |
| `grba` | `git rebase --abort` |
| `grbs` | `git rebase --skip` |

### Stash
| Abbr | Expands to |
|------|-----------|
| `gsta` | `git stash` |
| `gstd` | `git stash drop` |
| `gstl` | `git stash list` |
| `gstp` | `git stash pop` |
| `gsts` | `git stash show --text` |

### Reset / Restore
| Abbr | Expands to |
|------|-----------|
| `grh` | `git reset` |
| `grhh` | `git reset --hard` |
| `grhpa` | `git reset --patch` |
| `grs` | `git restore` |
| `grss` | `git restore --source` |
| `grst` | `git restore --staged` |

### Remote
| Abbr | Expands to |
|------|-----------|
| `gr` | `git remote -vv` |
| `gra` | `git remote add` |
| `grmv` | `git remote rename` |
| `grrm` | `git remote remove` |
| `grset` | `git remote set-url` |
| `grup` | `git remote update` |
| `grpo` | `git remote prune origin` |

### Merge
| Abbr | Expands to |
|------|-----------|
| `gm` | `git merge` |
| `gma` | `git merge --abort` |
| `gmom` | `git merge origin/<main-branch>` |
| `gmt` | `git mergetool --no-prompt` |

### Cherry-pick
| Abbr | Expands to |
|------|-----------|
| `gcp` | `git cherry-pick` |
| `gcpa` | `git cherry-pick --abort` |
| `gcpc` | `git cherry-pick --continue` |

### Tags
| Abbr | Expands to |
|------|-----------|
| `gts` | `git tag -s` |
| `gtv` | `git tag \| sort -V` |

### Worktrees
| Abbr | Expands to |
|------|-----------|
| `gwt` | `git worktree` |
| `gwta` | `git worktree add` |
| `gwtls` | `git worktree list` |
| `gwtpr` | `git worktree prune` |
| `gwtrm` | `git worktree remove` |
| `gwtmv` | `git worktree move` |

### Submodules
| Abbr | Expands to |
|------|-----------|
| `gsu` | `git submodule update` |
| `gsur` | `git submodule update --recursive` |
| `gsuri` | `git submodule update --recursive --init` |

### Bisect
| Abbr | Expands to |
|------|-----------|
| `gbs` | `git bisect` |
| `gbsb` | `git bisect bad` |
| `gbsg` | `git bisect good` |
| `gbsr` | `git bisect reset` |
| `gbss` | `git bisect start` |

### GitLab
| Abbr | Expands to |
|------|-----------|
| `gmr` | push + create MR on GitLab |
| `gmwps` | push + create MR + merge when pipeline succeeds |

### Git Flow
| Abbr | Expands to |
|------|-----------|
| `gfb` / `gfbs` / `gfbt` | `git flow bugfix` / `start` / `track` |
| `gff` / `gffs` / `gfft` | `git flow feature` / `start` / `track` |
| `gfr` / `gfrs` / `gfrt` | `git flow release` / `start` / `track` |
| `gfh` / `gfhs` / `gfht` | `git flow hotfix` / `start` / `track` |
| `gfp` | `git flow publish` |

### Misc
| Abbr | Expands to |
|------|-----------|
| `gignore` | `git update-index --assume-unchanged` |
| `gunignore` | `git update-index --no-assume-unchanged` |
| `grev` | `git revert` |
| `gcl` | `git clone` |
| `gclean` | `git clean -di` |
| `gclean!` | `git clean -dfx` |
| `gbl` | `git blame -b -w` |

---

## § 4  functions/ — Autoloaded Functions

FEYNMAN — fish autoloads functions from `functions/`. You never `source` them.
The first time you call `mkcd`, fish reads `functions/mkcd.fish` and defines it.
After that it's in memory for the session. This is different from zsh where you'd
source a functions file explicitly.

### Navigation

#### `mkcd <path>`
`mkdir -p` then `cd` in one step. You almost always want to cd into the dir you just created.

#### `up [n]`
Go up N directories. `up 3` = `cd ../../..`. Default: 1.

#### `fcd [root]`
Fuzzy cd: uses `fd` to list all directories, `fzf` to pick interactively with
eza tree preview on the right. Starts from `root` (default: cwd).

#### `cl [dir]`
`cd` then immediately `eza -la --git --time-style=relative`. The most common
"what's in this directory" flow in one command.

---

### File Operations

#### `fe [root]`
Fuzzy-find a file with fzf (bat preview on right), open in `$EDITOR`.

#### `bak <file>`
Backup with timestamp: `config.json` → `config.json.bak.20240115-143022`.

#### `extract <archive>`
Universal extractor. Handles: `.tar.gz` `.tar.bz2` `.tar.xz` `.tar.zst` `.tar`
`.bz2` `.gz` `.zip` `.7z` `.rar` `.Z` `.zst`.

#### `mkenv [src] [dst]`
Copy `.env.example` → `.env`. Refuses to overwrite existing `.env`.

#### `json [file]`
Pretty-print JSON from file or stdin, rendered with bat syntax highlighting.

#### `dotenv_check`
List variable names (not values) defined in `.env`. Safe to share in logs.

---

### FZF Utilities

#### `fh`
Fuzzy history search. Puts selected command on the command line (doesn't run it).
Different from `Ctrl-R`: `fh` lets you preview and choose; `Ctrl-R` is faster.

#### `fkill [signal]`
Shows all processes in fzf (multi-select with Tab), kills selected ones.
Default signal: `-9`. Example: `fkill -15`.

#### `rgv <pattern> [path]`
ripgrep → fzf → open nvim at the **exact line**.
Shows syntax-highlighted file preview with the matching line highlighted.

---

### Git Functions

#### `gsf` — fuzzy branch switcher
Lists all local + remote branches in fzf. Preview shows recent commits on
that branch. Enter switches to it.

#### `gaf` — fuzzy git add
Shows changed files with diff preview. Tab to multi-select. Runs `git add`
on selection, then shows `git status -sb`.

#### `glf` — interactive log browser
Browse commits in fzf. Preview shows stats. Enter opens full diff in `less`.

#### `gdf` — fuzzy diff picker
Pick a changed file from fzf (live diff preview), then `git diff` it.

#### `wip`
Quick WIP commit: stages everything, commits with `"wip: YYYY-MM-DD HH:MM [skip ci]"`.
Different from `gwip` (which uses `--no-verify` and removes deleted files).

#### `unwip`
Undo the last `wip` commit. Checks the commit message starts with `wip:`.
Keeps all changes staged (`git reset HEAD~1`).

#### `gsync`
Fetch + rebase current branch on `origin/<main-branch>`.
The cleanest way to stay current without messy merge commits.
If already on main, just does `git pull --rebase`.

#### `gstat`
Show all local branches with ahead/behind counts vs `origin/<main-branch>`.

#### `gclone <url|user/repo> [dir]`
Clone and cd into the repo. Supports GitHub shorthand: `gclone user/repo`.

#### `prco <number>`
`gh pr checkout <number>` — requires the `gh` CLI.

#### `git_open`
Opens the current repo on GitHub in the default browser. Converts SSH URL
to HTTPS automatically.

#### `gbage`
List all local branches sorted by last commit date, with age and author.

#### `gbda [-g]`
Delete all merged branches — including **squash-merged** ones (detects via
`git cherry`). Pass `-g` / `--gone` to also delete branches whose remote
tracking ref is gone.

#### `grename <old> <new>`
Rename a branch locally and on origin. Updates the remote tracking ref.

---

### Tmux Functions

#### `fts` — fuzzy session switcher
Lists all tmux sessions in fzf with window preview. Enter switches to it.

#### `tdev [name] [root]`
Create a structured dev tmux session:
- Window 1 `editor`: opens `nvim .`
- Window 2 `dev`: horizontal split (run server left, run tests right)

If session already exists, attaches/switches to it.
Usage: `tdev` (uses cwd name), `tdev myproject ~/projects/myproject`

---

### Node / JS

#### `nvmuse`
Read `.nvmrc` or `.node-version` in cwd and switch node version.
Uses `fnm` if available (10x faster), falls back to `nvm`.

#### `pnscript`
Parse `package.json` scripts with Python, pick one in fzf, run with `pnpm run`.
Preview shows the script command before you run it.

---

### Network / System

#### `myip`
Shows local IP (en0/en1 on macOS, `ip route` on Linux) and public IP via `api.ipify.org`.

#### `serve [port]`
One-liner HTTP server in cwd using `python3 -m http.server`. Default port: 8080.
Shows local and LAN URLs.

---

### Dotfiles Management

#### `stow_pkg <package>`
Stow a single dotfiles package:
```
stow_pkg zsh   → symlinks ~/.dotfiles/.config/zsh → ~/.config/zsh
```

#### `stow_all`
Restow every package in `~/.dotfiles/.config/`. Skips `alacritty`, `kitty`,
`wezterm` if the binary isn't installed (conditional packages).

---

## § 5  Themes

### Catppuccin Mocha — applied at every layer

| Layer | How |
|-------|-----|
| Terminal (Ghostty) | `theme = Catppuccin Mocha` in `~/.config/ghostty/config` |
| Fish shell colors | `catppuccin/fish` plugin sets `fish_color_*` variables |
| Starship prompt | `[palettes.catppuccin_mocha]` in `starship.toml` |
| Syntax highlighting | Fish built-in, themed by `catppuccin/fish` |
| bat | `BAT_THEME="Catppuccin Mocha"` |
| fzf | `FZF_DEFAULT_OPTS` colors in `env.fish` |
| eza columns | `EZA_COLORS` in `env.fish` |
| ls file types | `LS_COLORS` via `vivid generate catppuccin-mocha` |
| grep matches | `GREP_COLORS` in `env.fish` |
| gcc errors | `GCC_COLORS` in `env.fish` |
| git diffs | `delta` with `DELTA_FEATURES=catppuccin-mocha` |

Available Catppuccin fish themes (switch with `fish_config theme choose`):
- `Catppuccin Frappe`
- `Catppuccin Macchiato`
- `Catppuccin Mocha` ← active

---

## § 6  Tools Required

These tools are expected to be installed. Config gracefully degrades if missing.

| Tool | Install | Used for |
|------|---------|---------|
| `nvim` | `brew install neovim` | `$EDITOR`, all edit commands |
| `eza` | `brew install eza` | ls replacement |
| `bat` | `brew install bat` | cat replacement, man pager, previews |
| `fd` | `brew install fd` | find replacement, fzf source |
| `rg` | `brew install ripgrep` | grep replacement |
| `fzf` | `brew install fzf` | fuzzy finder (core tool) |
| `zoxide` | `brew install zoxide` | smart cd |
| `delta` | `brew install git-delta` | git diff pager |
| `vivid` | `brew install vivid` | LS_COLORS generator |
| `starship` | `brew install starship` | prompt |
| `tmux` | `brew install tmux` | terminal multiplexer |
| `fnm` | `brew install fnm` | fast Node version manager |
| `gh` | `brew install gh` | GitHub CLI (for `prco`) |
| `stow` | `brew install stow` | dotfiles symlink manager |
| `pnpm` | `brew install pnpm` | Node package manager |

---

## § 7  config.fish — Top-level Config

```fish
set -g fish_greeting ""          # silence "Welcome to fish"
fzf --fish | source              # install fzf native fish integration
source config-local.fish         # machine-specific overrides (not in git)
source envman/load.fish          # envman-managed env vars
```

FEYNMAN — why is config.fish so minimal?
Everything is split into `conf.d/` files. config.fish only holds things that
must run after conf.d/ (fish loads conf.d/ before config.fish) or things
that don't fit the conf.d/ pattern. The fzf native integration must run in
config.fish because it needs to happen after fzf.fish plugin is loaded.
