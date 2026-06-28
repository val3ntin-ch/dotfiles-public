# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Apply to a new machine

```bash
cd ~/.dotfiles
stow --target="$HOME" --restow .
```

Then install plugins:

```bash
fisher install            # fish plugins (reads fish_plugins)
# open tmux → <prefix> I  # tmux plugins (TPM)
ya pkg install            # yazi plugins (reads package.toml)
```

Zsh plugins (antidote) compile automatically on first shell start.

## Structure

All config lives under `.config/` and stows to `~/.config/`. Root-level `.zshenv` stows to `~/.zshenv` (sets `ZDOTDIR`).

| Directory | Tool |
|-----------|------|
| `.config/fish/` | Fish shell |
| `.config/zsh/` | Zsh |
| `.config/tmux/` | Tmux |
| `.config/ghostty/` | Ghostty terminal |
| `.config/starship/` | Starship prompt |
| `.config/sesh/` | Sesh session manager |
| `.config/yazi/` | Yazi file manager |

## Re-stow after changes

```bash
cd ~/.dotfiles
stow --target="$HOME" --restow .
```
