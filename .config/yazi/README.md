# Yazi — File Manager

Terminal file manager with full preview support (images, video, PDF, archives),
plugin system, and Catppuccin Mocha theming.

---

## Table of Contents

1. [Features](#features)
2. [Install](#install)
3. [Plugins](#plugins)
4. [Keybindings](#keybindings)
5. [Image preview](#image-preview)
6. [New machine bootstrap](#new-machine-bootstrap)

---

## Features

- Three-pane layout (1:2:4 ratio), dirs first
- Git status via `git.yazi` plugin (linemode decorations)
- Fast MIME detection via `mime-ext.yazi` (extension DB, not `file(1)`)
- Size linemode, symlink display, scrolloff=5
- Catppuccin Mocha via `theme.toml` + `Catppuccin-mocha.tmTheme` (bat syntax)

---

## Install

```bash
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick
```

Config stowed from `~/.dotfiles/.config/yazi/` → `~/.config/yazi/`.

---

## Plugins

Plugins installed via `ya pkg install` (reads `package.toml`). Not committed — reinstall on new machine.

| Plugin | Key | Description |
|---|---|---|
| `git.yazi` | — | Git status in file listing |
| `mime-ext.yazi` | — | Fast MIME detection |
| `smart-filter.yazi` | `f` | Live filter with regex |
| `jump-to-char.yazi` | `F` | Jump to file by first char |
| `chmod.yazi` | `gx` | Change file permissions |
| `diff.yazi` | `gd` | Diff selected files |

---

## Keybindings

Custom bindings (in addition to yazi defaults):

| Key | Action |
|---|---|
| `f` | Smart filter |
| `F` | Jump to char |
| `gd` | Diff selected |
| `gx` | Chmod selected |
| `Ctrl+h` | Toggle hidden files |
| `!` | Open shell in current dir |

---

## Image preview

Yazi detects the best available image protocol:

| Context | Protocol | Quality |
|---|---|---|
| Ghostty (direct) | Kitty Graphics Protocol | Full resolution |
| Inside tmux | Chafa (fallback) | ASCII art |

To get full image preview in tmux, `TERM_PROGRAM` must propagate through.
`tmux/options.conf` has `allow-passthrough on` + `update-environment TERM_PROGRAM` for this.

---

## New machine bootstrap

```bash
# 1. Install yazi and deps
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick

# 2. Stow config
cd ~/.dotfiles && stow --target="$HOME" --restow .

# 3. Install plugins
ya pkg install

# 4. Done
```
