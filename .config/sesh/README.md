# Sesh — Tmux Session Manager

A standalone Go binary that replaces sessionx/sessionist for tmux session
management. Merges active sessions, zoxide frecency dirs, and pinned sessions
into a single fzf picker. Zero tmux plugin dependency.

---

## Table of Contents

1. [How it works](#how-it-works)
2. [Keybinding](#keybinding)
3. [Picker UI](#picker-ui)
4. [sesh.toml — pinned sessions](#seshtoml--pinned-sessions)
5. [CLI reference](#cli-reference)

---

## How it works

```
prefix + o  →  fzf-tmux popup
               ├─ Pinned sessions    (sesh.toml)
               ├─ Active sessions    (running tmux sessions)
               └─ Zoxide dirs        (frecency-ranked directories)
                         ↓
                    pick one
                         ↓
               session exists?  →  switch to it
               session missing? →  create it (runs startup_command if set)
```

Sesh is **not a tmux plugin** — it's a binary called by a tmux keybinding.
Changes to `sesh.toml` take effect immediately, no tmux reload needed.

---

## Keybinding

Defined in `~/.config/tmux/keybindings.conf`:

```
prefix + o
```

Opens an 80%×70% fzf-tmux popup with:
- Nerd Font icons per session type
- Right-side preview (40%) showing windows/panes inside the session
- No sort — pinned sessions stay at top

---

## Picker UI

```
┌─────────────────── sesh ────────────────────────────────┐
│ > dotfiles                      │  windows: 2           │
│   config                        │  1: nvim              │
│   ─── active sessions ───       │  2: fish              │
│   main                          │                       │
│   ─── zoxide dirs ───           │                       │
│   ~/dev/myapp                   │                       │
│   ~/dev/api                     │                       │
└─────────────────────────────────┴───────────────────────┘
```

| Key | Action |
|---|---|
| `Enter` | connect / create session |
| `Ctrl+d` | kill selected session |
| `Ctrl+j/k` or `↑/↓` | navigate |
| `Esc` / `Ctrl+c` | cancel |
| Type to filter | fuzzy search across all entries |

---

## sesh.toml — pinned sessions

`~/.config/sesh/sesh.toml` defines sessions that always appear at the top
of the picker, even when not running.

```toml
[[session]]
name = "dotfiles"
path = "~/.dotfiles"
startup_command = "nvim"   # runs only on first create, not on re-connect

[[session]]
name = "config"
path = "~/.config"
```

### Fields

| Field | Required | Description |
|---|---|---|
| `name` | yes | session name shown in picker and tmux |
| `path` | yes | working directory for the session |
| `startup_command` | no | shell command run once on first create |

### Adding a project

```toml
[[session]]
name = "myapp"
path = "~/dev/myapp"
startup_command = "nvim ."
```

After saving, `prefix + o` immediately shows the new entry — no reload.

---

## CLI reference

```bash
# List all sessions sesh knows about (active + zoxide + pinned)
sesh list

# List with Nerd Font icons (used by the tmux keybinding)
sesh list --icons

# Connect to a session by name (creates if missing)
sesh connect dotfiles

# Preview windows/panes of a session
sesh preview dotfiles

# Kill a session
sesh kill dotfiles
```

---

Sesh reads zoxide's database automatically — the more you `cd`, the richer
the picker gets over time.
