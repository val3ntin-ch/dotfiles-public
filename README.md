# dotfiles

Personal dotfiles — Fish, Zsh, Tmux, Neovim, Yazi, Ghostty. Catppuccin Mocha everywhere.  
Packages via [Nix](https://nixos.org) + [home-manager](https://nix-community.github.io/home-manager/). Symlinks via [GNU Stow](https://www.gnu.org/software/stow/).

---

## Install

```bash
git clone https://github.com/valentinhc/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script handles everything:

| Step | What |
|---|---|
| 1 | Install Nix (Determinate Systems — macOS + Linux) |
| 2 | Add `nixpkgs-unstable` + `home-manager` channels |
| 3 | `home-manager switch` — installs all packages and fonts |
| 4 | `stow` — symlinks `~/.dotfiles` → `$HOME` |
| 5 | `fisher install` — fish plugins |
| 6 | `ya pkg install` — yazi plugins |

After the script finishes, open a new terminal. Tmux plugins auto-install on first start. Antidote (zsh plugins) compiles on first zsh start.

---

## Add or remove a package

Edit `nix/home.nix`, then:

```bash
home-manager switch -f ~/.dotfiles/nix/home.nix
```

---

## Re-stow after config changes

```bash
cd ~/.dotfiles && stow --target="$HOME" --restow .
```

---

## Structure

```
~/.dotfiles/
├── install.sh          ← bootstrap (run once on new machine)
├── nix/
│   └── home.nix        ← all packages (edit here to add/remove tools)
├── .zshenv             ← sets ZDOTDIR, stows to ~/.zshenv
└── .config/
    ├── fish/           ← Fish shell
    ├── zsh/            ← Zsh
    ├── tmux/           ← Tmux
    ├── ghostty/        ← Ghostty terminal
    ├── starship/       ← Starship prompt
    ├── sesh/           ← Sesh session manager
    └── yazi/           ← Yazi file manager
```

---

## Plugin managers (post-install)

| Tool | Manager | Command |
|---|---|---|
| Fish plugins | Fisher | `fisher install` (reads `fish_plugins`) |
| Zsh plugins | Antidote | auto on first `zsh` start |
| Tmux plugins | TPM | auto on first `tmux` start, or `<prefix> I` |
| Yazi plugins | ya pkg | `ya pkg install` (reads `package.toml`) |
| Node versions | fnm | `fnm install --lts` |
