# dotfiles

---

## Install (macOS)

```bash
git clone https://github.com/val3ntin-ch/.dotfiles ~/.dotfiles
~/.dotfiles/install.sh
```

Open a new terminal when done. Zsh is the default shell with all plugins active.

---

## What install.sh does

1. Installs Homebrew (if missing)
2. Installs all tools via `brew`
3. Installs Ghostty + Nerd Fonts via `brew --cask`
4. Stows dotfiles to `$HOME` via GNU Stow
5. Sets zsh as default shell
6. Installs fish plugins via Fisher
7. Bootstraps tmux plugins via TPM
8. Installs Node LTS via fnm

---

## Installed tools

### Terminal & shells
| Tool | Purpose |
|---|---|
| [Ghostty](https://ghostty.org) | Terminal emulator |
| [fish](https://fishshell.com) | Interactive shell |
| [zsh](https://zsh.sourceforge.io) | Default shell |
| [starship](https://starship.rs) | Prompt (shared by fish + zsh) |

### Core CLI
| Tool | Purpose |
|---|---|
| [neovim](https://neovim.io) | Editor |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [yazi](https://yazi-rs.github.io) | File manager |
| [git](https://git-scm.com) | Version control |
| [gh](https://cli.github.com) | GitHub CLI |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [git-delta](https://dandavison.github.io/delta) | Diff pager |
| [sesh](https://github.com/joshmedeski/sesh) | Tmux session manager |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart cd |
| [eza](https://eza.rocks) | Modern ls |
| [bat](https://github.com/sharkdp/bat) | Modern cat |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep |
| [fd](https://github.com/sharkdp/fd) | Fast find |
| [vivid](https://github.com/sharkdp/vivid) | LS_COLORS generator |
| [ouch](https://github.com/ouch-org/ouch) | Archive tool |
| [jq](https://jqlang.github.io/jq) | JSON processor |

### Yazi dependencies
| Tool | Purpose |
|---|---|
| ffmpeg-full | Video preview |
| imagemagick-full | Image preview |
| poppler | PDF preview |
| resvg | SVG preview |
| sevenzip | Archive preview |

### Language runtimes & managers
| Tool | Purpose |
|---|---|
| [fnm](https://github.com/Schniz/fnm) + Node LTS | Node version manager |
| [pnpm](https://pnpm.io) | Node package manager |
| [go](https://go.dev) | Go |
| [pyenv](https://github.com/pyenv/pyenv) | Python version manager |
| [rbenv](https://github.com/rbenv/rbenv) | Ruby version manager |

### Fish plugins (via Fisher)
| Plugin | Purpose |
|---|---|
| [jorgebucaran/fisher](https://github.com/jorgebucaran/fisher) | Plugin manager |
| [kidonng/zoxide.fish](https://github.com/kidonng/zoxide.fish) | Zoxide integration |
| [patrickf1/fzf.fish](https://github.com/PatrickF1/fzf.fish) | fzf key bindings |
| [jhillyerd/plugin-git](https://github.com/jhillyerd/plugin-git) | Git abbreviations |
| [catppuccin/fish](https://github.com/catppuccin/fish) | Catppuccin Mocha theme |
| [budimanjojo/tmux.fish](https://github.com/budimanjojo/tmux.fish) | Tmux integration |

### Zsh plugins (via antidote)
| Plugin | Purpose |
|---|---|
| zsh-users/zsh-completions | Completion definitions for 100+ tools |
| zdharma-continuum/fast-syntax-highlighting | As-you-type syntax coloring |
| zsh-users/zsh-autosuggestions | Fish-style ghost text history |
| zsh-users/zsh-history-substring-search | ↑/↓ search by substring |
| Aloxaf/fzf-tab | Replace completion menu with fzf |
| jeffreytse/zsh-vi-mode | Full vi keybindings + text objects |
| hlissner/zsh-autopair | Auto-close brackets, quotes |
| kutsan/zsh-system-clipboard | Vi-mode yank/paste ↔ system clipboard |
| MichaelAquilina/zsh-you-should-use | Reminds you to use your aliases |
| mollifier/cd-gitroot | `cdg` — jump to git repo root |
| ohmyzsh/tmux | Session aliases + completions |
| ohmyzsh/colored-man-pages | Colored man pages |
| ohmyzsh/dotenv | Auto-source `.env` on `cd` |
| ohmyzsh/magic-enter | Enter on empty prompt → `eza -la` or `git status` |

### Tmux plugins (via TPM)
| Plugin | Purpose |
|---|---|
| tmux-plugins/tmux-sensible | Sane defaults |
| tmux-plugins/tmux-resurrect | Save/restore sessions |
| tmux-plugins/tmux-continuum | Auto-save every 15 min |
| tmux-plugins/tmux-yank | System clipboard integration |
| christoomey/vim-tmux-navigator | Seamless pane/split nav with Neovim |
| sainnhe/tmux-fzf | fzf-powered tmux actions |
| wfxr/tmux-fzf-url | Open URLs from pane with fzf |
| catppuccin/tmux | Catppuccin Mocha theme |
| tmux-plugins/tmux-cpu | CPU in status bar |
| tmux-plugins/tmux-battery | Battery in status bar |

### Fonts
| Font | Purpose |
|---|---|
| JetBrains Mono Nerd Font | Main monospace font |
| Symbols Only Nerd Font | Nerd Font icons fallback |

---

## Structure

```
~/.dotfiles/
├── install.sh          → macOS bootstrap
├── .zshenv             → ~/.zshenv (sets ZDOTDIR)
└── .config/
    ├── fish/           → Fish shell
    ├── zsh/            → Zsh (ZDOTDIR = ~/.config/zsh)
    ├── tmux/           → Tmux
    ├── ghostty/        → Ghostty terminal
    ├── starship/       → Starship prompt
    ├── sesh/           → Sesh session manager
    └── yazi/           → Yazi file manager
```

---

## Re-stow after changes

```bash
cd ~/.dotfiles && stow --target="$HOME" --restow .
```

---

## Yazi plugins (optional)

Not installed by `install.sh`. Run manually:

```bash
ya pkg install
```
