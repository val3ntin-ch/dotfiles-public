#!/usr/bin/env bash

# install nix
curl -L https://nixos.org/nix/install | sh

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
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

# stow dotfiles
cd "$(dirname "$0")"
stow --target="$HOME" --restow .

# set zsh as default shell
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(which zsh)" "$USER"

# install fish plugins
fish -c "
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
    fisher install < ~/.config/fish/fish_plugins
"

# install yazi plugins
ya pkg install

# macOS only
[ "$(uname -s)" = 'Darwin' ] && nix-env -iA nixpkgs.ghostty
