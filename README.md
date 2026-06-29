# dotfiles

Fish, Zsh, Tmux, Neovim, Yazi, Ghostty. Catppuccin Mocha everywhere.  
Symlinks via [GNU Stow](https://www.gnu.org/software/stow/).

---

## 1. Install packages

### macOS
```bash
brew install fish zsh starship antidote neovim git gh lazygit git-delta \
             stow tmux sesh fzf fd bat eza ripgrep zoxide vivid jq \
             yazi ffmpeg imagemagick poppler resvg sevenzip ouch \
             fnm pnpm go pyenv rbenv

brew install --cask ghostty
brew install joshmedeski/sesh/sesh

# Fonts
brew install --cask font-jetbrains-mono-nerd-font font-symbols-only-nerd-font
```

### Linux
```bash
# Nix (recommended — installs everything in one place)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

nix profile add \
    github:NixOS/nixpkgs/nixos-25.11#fish \
    github:NixOS/nixpkgs/nixos-25.11#zsh \
    github:NixOS/nixpkgs/nixos-25.11#starship \
    github:NixOS/nixpkgs/nixos-25.11#antidote \
    github:NixOS/nixpkgs/nixos-25.11#neovim \
    github:NixOS/nixpkgs/nixos-25.11#git \
    github:NixOS/nixpkgs/nixos-25.11#gh \
    github:NixOS/nixpkgs/nixos-25.11#lazygit \
    github:NixOS/nixpkgs/nixos-25.11#diff-so-fancy \
    github:NixOS/nixpkgs/nixos-25.11#stow \
    github:NixOS/nixpkgs/nixos-25.11#tmux \
    github:NixOS/nixpkgs/nixos-25.11#sesh \
    github:NixOS/nixpkgs/nixos-25.11#fzf \
    github:NixOS/nixpkgs/nixos-25.11#fd \
    github:NixOS/nixpkgs/nixos-25.11#bat \
    github:NixOS/nixpkgs/nixos-25.11#eza \
    github:NixOS/nixpkgs/nixos-25.11#ripgrep \
    github:NixOS/nixpkgs/nixos-25.11#zoxide \
    github:NixOS/nixpkgs/nixos-25.11#vivid \
    github:NixOS/nixpkgs/nixos-25.11#jq \
    github:NixOS/nixpkgs/nixos-25.11#yazi \
    github:NixOS/nixpkgs/nixos-25.11#ffmpeg \
    github:NixOS/nixpkgs/nixos-25.11#imagemagick \
    github:NixOS/nixpkgs/nixos-25.11#poppler \
    github:NixOS/nixpkgs/nixos-25.11#resvg \
    github:NixOS/nixpkgs/nixos-25.11#p7zip \
    github:NixOS/nixpkgs/nixos-25.11#ouch \
    github:NixOS/nixpkgs/nixos-25.11#fnm \
    github:NixOS/nixpkgs/nixos-25.11#pnpm \
    github:NixOS/nixpkgs/nixos-25.11#go \
    github:NixOS/nixpkgs/nixos-25.11#pyenv \
    github:NixOS/nixpkgs/nixos-25.11#rbenv \
    github:NixOS/nixpkgs/nixos-25.11#ghostty \
    github:NixOS/nixpkgs/nixos-25.11#xclip

# Fonts
nix profile add \
    github:NixOS/nixpkgs/nixos-25.11#nerd-fonts.jetbrains-mono \
    github:NixOS/nixpkgs/nixos-25.11#nerd-fonts.symbols-only
fc-cache -fv
```

---

## 2. Clone & stow

```bash
git clone https://github.com/val3ntin-ch/.dotfiles ~/.dotfiles
cd ~/.dotfiles
stow --target="$HOME" --restow .
```

---

## 3. Set default shell

```bash
# macOS
chsh -s $(which zsh)

# Linux
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
chsh -s "$HOME/.nix-profile/bin/zsh"
```

---

## 4. Plugins

Open a new terminal, then:

```bash
# Fish plugins
fisher install

# Yazi plugins
ya pkg install

# Tmux plugins — auto-install on first tmux start, or:
# open tmux → <prefix> I

# Zsh plugins (antidote) — auto-compile on first zsh start

# Node
fnm install --lts
```

---

## Structure

```
~/.dotfiles/
├── .zshenv             → ~/.zshenv  (sets ZDOTDIR)
└── .config/
    ├── fish/           → Fish shell
    ├── zsh/            → Zsh
    ├── tmux/           → Tmux
    ├── ghostty/        → Ghostty terminal
    ├── starship/       → Starship prompt
    ├── sesh/           → Sesh session manager
    └── yazi/           → Yazi file manager
```

## Re-stow after changes

```bash
cd ~/.dotfiles && stow --target="$HOME" --restow .
```
