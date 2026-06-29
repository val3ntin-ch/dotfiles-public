#!/usr/bin/env bash

# ── 1. Nix ────────────────────────────────────────────────────────────────────
if [ ! -d /nix ]; then
    curl --proto '=https' --tlsv1.2 -sSf -L \
        https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi

# source nix — multi-user (Determinate) path first, single-user fallback
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# ── 2. Packages ───────────────────────────────────────────────────────────────
packages=(
    nixpkgs#fish
    nixpkgs#zsh
    nixpkgs#starship
    nixpkgs#antidote
    nixpkgs#neovim
    nixpkgs#git
    github:NixOS/nixpkgs/nixpkgs-unstable#git-delta
    nixpkgs#gh
    nixpkgs#lazygit
    nixpkgs#git-filter-repo
    nixpkgs#stow
    nixpkgs#tmux
    nixpkgs#sesh
    nixpkgs#fzf
    nixpkgs#fd
    nixpkgs#bat
    nixpkgs#eza
    nixpkgs#ripgrep
    nixpkgs#zoxide
    nixpkgs#vivid
    nixpkgs#jq
    nixpkgs#yazi
    nixpkgs#ffmpeg
    nixpkgs#imagemagick
    nixpkgs#poppler
    nixpkgs#resvg
    nixpkgs#p7zip
    nixpkgs#ouch
    nixpkgs#fnm
    nixpkgs#pnpm
    nixpkgs#go
    nixpkgs#pyenv
    nixpkgs#rbenv
)

[ "$(uname -s)" = 'Darwin' ] && packages+=(nixpkgs#ghostty)

for pkg in "${packages[@]}"; do
    echo "installing $pkg..."
    nix profile add "$pkg" || echo "WARN: $pkg failed — skipping"
done

# reload PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

# ── 3. Dotfiles symlinks ──────────────────────────────────────────────────────
cd "$(dirname "$0")"
stow --target="$HOME" --restow .

# ── 4. Default shell ──────────────────────────────────────────────────────────
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(which zsh)" "$USER"

# ── 5. Fish plugins ───────────────────────────────────────────────────────────
fish -c "
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
    fisher install < ~/.config/fish/fish_plugins
"

# ── 6. Yazi plugins ───────────────────────────────────────────────────────────
ya pkg install
