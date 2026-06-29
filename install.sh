#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"   # Darwin | Linux

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; RESET='\033[0m'
step()  { echo -e "\n${BLUE}==>${RESET} $*"; }
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
note()  { echo -e "${YELLOW}→${RESET} $*"; }
err()   { echo -e "${RED}✗${RESET} $*" >&2; }

# ── Stable channels — NixOS 25.11 (November 2025) ────────────────────────────
# Same package versions on every machine, every switch.
# To upgrade: bump both URLs + stateVersion in nix/home.nix to next release (26.05).
if [[ "$OS" == "Darwin" ]]; then
  NIXPKGS_CHANNEL_URL="https://nixos.org/channels/nixpkgs-25.11-darwin"
else
  NIXPKGS_CHANNEL_URL="https://nixos.org/channels/nixos-25.11"
fi
HM_CHANNEL_URL="https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz"

# ── Pre-flight ────────────────────────────────────────────────────────────────
step "Pre-flight"
if ! command -v curl &>/dev/null; then
  err "curl is required but not found. Install curl and retry."
  exit 1
fi
ok "curl present"
if ! command -v git &>/dev/null; then
  err "git is required but not found. Install git and retry."
  exit 1
fi
ok "git present"

# ── 1. Nix ────────────────────────────────────────────────────────────────────
step "Nix"
if command -v nix &>/dev/null; then
  ok "Nix already installed ($(nix --version))"
else
  note "Installing Nix via Determinate Systems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install --no-confirm
  ok "Nix installed"
fi

# Source Nix into current shell session (works for both macOS and Linux)
NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
if [ -f "$NIX_PROFILE" ]; then
  # shellcheck disable=SC1090
  . "$NIX_PROFILE"
fi

# ── 2. Nix channels (stable 25.11) ────────────────────────────────────────────
step "Nix channels"
# Always set channels to pinned URLs — overwrites any existing version.
# Ensures home-manager and nixpkgs stay on the same release.
nix-channel --add "$NIXPKGS_CHANNEL_URL" nixpkgs
ok "nixpkgs → $NIXPKGS_CHANNEL_URL"
nix-channel --add "$HM_CHANNEL_URL" home-manager
ok "home-manager → $HM_CHANNEL_URL"

note "Updating channels (downloads package index — may take a few minutes)..."
nix-channel --update
ok "Channels updated"

# ── 3. home-manager ───────────────────────────────────────────────────────────
step "home-manager"
if ! command -v home-manager &>/dev/null; then
  note "Installing home-manager..."
  nix-shell '<home-manager>' -A install
  ok "home-manager installed"
else
  ok "home-manager already installed"
fi

# ── 4. Packages ───────────────────────────────────────────────────────────────
# nix/home.nix is the source of truth for all packages.
# To add/remove a package: edit nix/home.nix, then run:
#   home-manager switch -f ~/.dotfiles/nix/home.nix
step "Packages (home-manager switch)"
note "Installing all packages from nix/home.nix — this will take a while on first run..."
home-manager switch -f "$DOTFILES/nix/home.nix"
ok "All packages installed"

# Reload PATH so tools installed by home-manager are available in this session.
# home-manager puts binaries in ~/.nix-profile/bin.
export PATH="$HOME/.nix-profile/bin:$PATH"

# Linux: refresh font cache after home-manager installs fonts to ~/.local/share/fonts
if [[ "$OS" == "Linux" ]] && command -v fc-cache &>/dev/null; then
  fc-cache -f
  ok "Font cache refreshed"
fi

# ── 5. Dotfiles symlinks ──────────────────────────────────────────────────────
# Stow creates symlinks: ~/.dotfiles/.config/fish → ~/.config/fish (directory folding).
# If you see conflicts, remove the conflicting file/dir from $HOME then re-run.
step "Stow"
cd "$DOTFILES"

# Dry-run first — catch conflicts before making any changes
if ! stow --simulate --target="$HOME" --restow . 2>/dev/null; then
  err "Stow conflicts detected. Conflicting paths:"
  stow --simulate --target="$HOME" --restow . 2>&1 || true
  err "Remove the conflicting files from \$HOME, then re-run: cd ~/.dotfiles && stow --target=\"\$HOME\" --restow ."
  exit 1
fi

stow --target="$HOME" --restow .
ok "Dotfiles stowed to $HOME"

# ── 6. Fish plugins ───────────────────────────────────────────────────────────
step "Fish plugins (Fisher)"
if command -v fish &>/dev/null; then
  if [ -f "$HOME/.config/fish/fish_plugins" ]; then
    note "Installing Fisher + fish plugins..."
    fish -c "
      if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish \
          | source
        fisher install jorgebucaran/fisher
      end
      fisher install < ~/.config/fish/fish_plugins
    "
    ok "Fish plugins installed"
  else
    note "fish_plugins not found — skipping"
  fi
else
  note "fish not in PATH — open a new terminal and run: fisher install"
fi

# ── 7. Yazi plugins ───────────────────────────────────────────────────────────
step "Yazi plugins"
if command -v ya &>/dev/null; then
  ya pkg install
  ok "Yazi plugins installed"
else
  note "ya not in PATH — open a new terminal and run: ya pkg install"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}All done.${RESET}"
echo ""
echo "Open a new terminal, then:"
echo "  tmux              → plugins auto-install on first start  (or <prefix> I)"
echo "  zsh               → antidote compiles plugins on first start"
echo "  fnm install --lts → install a Node.js version"
