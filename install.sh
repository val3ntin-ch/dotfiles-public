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

# ── Stable nixpkgs 25.11 ─────────────────────────────────────────────────────
# Full GitHub ref bypasses Determinate Nix registry — guarantees stable 25.11.
# macOS: nixpkgs-25.11-darwin   Linux: nixos-25.11
if [ "$(uname -s)" = 'Darwin' ]; then
    NIX="github:NixOS/nixpkgs/nixpkgs-25.11-darwin"
else
    NIX="github:NixOS/nixpkgs/nixos-25.11"
fi

# ── 2. Packages ───────────────────────────────────────────────────────────────
packages=(
    "$NIX#fish"
    "$NIX#zsh"
    "$NIX#starship"
    "$NIX#antidote"
    "$NIX#neovim"
    "$NIX#git"
    "$NIX#git-delta"
    "$NIX#gh"
    "$NIX#lazygit"
    "$NIX#git-filter-repo"
    "$NIX#stow"
    "$NIX#tmux"
    "$NIX#sesh"
    "$NIX#fzf"
    "$NIX#fd"
    "$NIX#bat"
    "$NIX#eza"
    "$NIX#ripgrep"
    "$NIX#zoxide"
    "$NIX#vivid"
    "$NIX#jq"
    "$NIX#yazi"
    "$NIX#ffmpeg"
    "$NIX#imagemagick"
    "$NIX#poppler"
    "$NIX#resvg"
    "$NIX#p7zip"
    "$NIX#ouch"
    "$NIX#fnm"
    "$NIX#pnpm"
    "$NIX#go"
    "$NIX#pyenv"
    "$NIX#rbenv"
    "$NIX#ghostty"
)

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
