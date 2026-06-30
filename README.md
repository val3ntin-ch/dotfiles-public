# dotfiles

Fish, Zsh, Tmux, Neovim, Yazi, Ghostty. Catppuccin Mocha everywhere.  
Symlinks via [GNU Stow](https://www.gnu.org/software/stow/).

---

## Install (macOS)

```bash
git clone https://github.com/val3ntin-ch/.dotfiles ~/.dotfiles
~/.dotfiles/install.sh
```

Open a new terminal when done. Zsh is now the default shell with all plugins active.

---

## What install.sh does

1. Installs Homebrew (if missing)
2. Installs all tools via `brew` — fish, zsh, tmux, neovim, yazi, starship, fzf, eza, bat, and more
3. Installs Ghostty + Nerd Fonts via `brew --cask`
4. Stows dotfiles to `$HOME` via GNU Stow
5. Sets zsh as the default shell
6. Installs fish plugins via Fisher
7. Bootstraps tmux plugins via TPM
8. Installs Node LTS via fnm

---

## Structure

```
~/.dotfiles/
├── install.sh          → bootstrap (macOS)
├── .zshenv             → ~/.zshenv  (sets ZDOTDIR)
└── .config/
    ├── fish/           → Fish shell
    ├── zsh/            → Zsh (ZDOTDIR = ~/.config/zsh)
    ├── tmux/           → Tmux
    ├── ghostty/        → Ghostty terminal
    ├── starship/       → Starship prompt (shared by fish + zsh)
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

Yazi plugins are not installed by `install.sh`. To install them:

```bash
ya pkg install
```
