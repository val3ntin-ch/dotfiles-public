#!/usr/bin/env bash

# ── 1. Nix ────────────────────────────────────────────────────────────────────
# Check /nix dir — not command -v (nix not in PATH before sourcing profile)
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

# ── 2. nixpkgs channel ────────────────────────────────────────────────────────
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

# ── 3. Packages ───────────────────────────────────────────────────────────────
nix-env -iA \
    nixpkgs.fish \
    nixpkgs.zsh \
    nixpkgs.starship \
    nixpkgs.antidote \
    nixpkgs.neovim \
    nixpkgs.git \
    nixpkgs.git-delta \
    nixpkgs.gh \
    nixpkgs.lazygit \
    nixpkgs.git-filter-repo \
    nixpkgs.stow \
    nixpkgs.tmux \
    nixpkgs.sesh \
    nixpkgs.fzf \
    nixpkgs.fd \
    nixpkgs.bat \
    nixpkgs.eza \
    nixpkgs.ripgrep \
    nixpkgs.zoxide \
    nixpkgs.vivid \
    nixpkgs.jq \
    nixpkgs.yazi \
    nixpkgs.ffmpeg \
    nixpkgs.imagemagick \
    nixpkgs.poppler \
    nixpkgs.resvg \
    nixpkgs.p7zip \
    nixpkgs.ouch \
    nixpkgs.fnm \
    nixpkgs.pnpm \
    nixpkgs.go \
    nixpkgs.pyenv \
    nixpkgs.rbenv

# macOS only
[ "$(uname -s)" = 'Darwin' ] && nix-env -iA nixpkgs.ghostty

# ── 4. Dotfiles symlinks ──────────────────────────────────────────────────────
cd "$(dirname "$0")"
stow --target="$HOME" --restow .

# ── 5. Default shell ──────────────────────────────────────────────────────────
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(which zsh)" "$USER"

# ── 6. Fish plugins ───────────────────────────────────────────────────────────
fish -c "
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
    fisher install < ~/.config/fish/fish_plugins
"

# ── 7. Yazi plugins ───────────────────────────────────────────────────────────
ya pkg install
