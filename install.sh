#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
step() { printf '\n\033[1;36m==> %s\033[0m\n' "$1"; }

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
step "Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -x /usr/local/bin/brew    ]] && eval "$(/usr/local/bin/brew shellenv)"
fi
brew update

# ── 2. Core tools ─────────────────────────────────────────────────────────────
step "Core tools"
brew install \
  fish zsh starship antidote neovim git gh lazygit git-delta \
  stow tmux vivid ouch bat eza fnm pnpm go pyenv rbenv \
  tree-sitter

# ── 3. Yazi + required dependencies ──────────────────────────────────────────
step "Yazi + dependencies"
brew install \
  yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full
brew link ffmpeg-full imagemagick-full -f --overwrite

# ── 4. Sesh (custom tap) ──────────────────────────────────────────────────────
step "Sesh"
brew install joshmedeski/sesh/sesh

# ── 5. Ghostty + fonts ────────────────────────────────────────────────────────
step "Ghostty + fonts"
brew install --cask ghostty font-jetbrains-mono-nerd-font font-symbols-only-nerd-font

# ── 6. Stow dotfiles ──────────────────────────────────────────────────────────
step "Stowing dotfiles"
# back up any real dirs that would conflict with stow symlinks
[[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
(cd "$DOTFILES" && stow --target="$HOME" --restow .)

# ── 7. Default shell → zsh ────────────────────────────────────────────────────
step "Default shell → zsh"
ZSH_PATH="$(brew --prefix)/bin/zsh"
grep -qF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
chsh -s "$ZSH_PATH"

# ── 8. Fish plugins ───────────────────────────────────────────────────────────
step "Fish plugins"
fish -c "
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
  fisher install
"

# ── 9. Tmux plugins (TPM auto-bootstrap) ─────────────────────────────────────
step "Tmux plugins"
tmux new-session -d -s _setup -x 220 -y 50 2>/dev/null || true
sleep 6
tmux kill-session -t _setup 2>/dev/null || true

# ── 10. Node LTS ──────────────────────────────────────────────────────────────
step "Node LTS"
eval "$(fnm env --log-level quiet)"
fnm install --lts

printf '\n\033[1;32m✓ Done. Open a new terminal — zsh is your default shell.\033[0m\n'
printf '  Next steps:\n'
printf '    nvim                  → first launch installs all plugins (~2-5 min)\n'
printf '    :LazyHealth           → verify everything is working\n'
printf '    ya pkg install        → install yazi plugins (optional)\n\n'
