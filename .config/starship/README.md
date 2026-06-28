# Starship Prompt Configuration

A cross-shell prompt shared by both Fish and Zsh. Single `starship.toml` file,
two palettes (Catppuccin Mocha active, Neon Cyberpunk available), zero startup
cost after first render.

---

## Table of Contents

1. [How starship works](#how-starship-works)
2. [Prompt layout](#prompt-layout)
3. [Left prompt modules](#left-prompt-modules)
4. [Right prompt modules](#right-prompt-modules)
5. [Module reference](#module-reference)
6. [Palettes](#palettes)
7. [Switching themes](#switching-themes)
8. [Testing & debugging](#testing--debugging)
9. [Adding a module](#adding-a-module)

---

## How starship works

Starship is a binary (`starship`) that both Fish and Zsh call at each prompt
draw. Each shell hands off prompt rendering entirely — Fish calls
`starship init fish`, Zsh calls `starship init zsh`. One config file,
identical prompt in both shells.

Config lives at `~/.config/starship/starship.toml` (XDG default).
Stowed from `~/.dotfiles/.config/starship/starship.toml`.

**Module auto-hiding**: every language module (Node, Python, Rust, etc.) only
appears when the current directory contains a relevant file (e.g. `package.json`
for Node, `pyproject.toml` for Python). No manual toggling needed — the prompt
is always minimal unless context requires otherwise.

---

## Prompt layout

```
LEFT                                        RIGHT
──────────────────────────────────────────────────────────────────────────
 ~/dev/project ❯                git branch git_status  node  cmd_dur  time
 user@host ~/dev ❯              (on SSH or root only)
```

- **Left**: shell context (SSH/root) + directory + prompt character
- **Right**: git state → infra context → language versions → timing

Two-sided layout keeps the left prompt minimal while surfacing all context
on the right — readable even in narrow terminals.

---

## Left prompt modules

### `$username` — SSH / root only

```toml
[username]
show_always = false     # silent on local non-root shells
style_user = "bold fg:blue"
style_root = "bold fg:red"
format = "[$user]($style)@"
```

Appears only when `SSH_CONNECTION` is set or the user is root. On a local
shell as a normal user: invisible.

### `$hostname`

```toml
[hostname]
ssh_only = true
```

Paired with username — only on SSH. Shows which machine you're on.

### `$directory`

```toml
[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music"     = "󰝚 "
"Pictures"  = " "
"Developer" = "󰲋 "
```

Common directories replaced with Nerd Font icons. Default truncation at 3
components from the repo root (`truncate_to_repo = true` is starship's default).

### `$character`

| Mode | Symbol | Color |
|---|---|---|
| Normal (insert) | `❯` | green |
| Error | `❯` | red |
| Vi normal | `❯v!❮` | green |
| Vi replace-one | `❮` | lavender |
| Vi replace | `❮` | lavender |
| Vi visual | `❮` | yellow |

`v!` in vi normal mode is intentional — personal signature.

---

## Right prompt modules

### Git

| Module | What it shows |
|---|---|
| `$git_branch` | ` main` — branch name with Nerd Font symbol |
| `$git_status` | `!3` modified · `+2` staged · `?1` untracked · `✘1` deleted · `*1` stashed · `=1` conflict · `⇡1` ahead · `⇣1` behind · `⇕⇡1⇣1` diverged |

### Infra / cloud (auto-hide — only when context active)

| Module | Trigger | Shows |
|---|---|---|
| `$docker_context` | active Docker context (not `default`) | `  context-name` |
| `$kubernetes` | `~/.kube/config` present + context set | `󱃾 context (namespace)` |
| `$aws` | `AWS_PROFILE` or `~/.aws/credentials` | `󰅟  profile (region)` |
| `$terraform` | `.terraform/` dir exists | `󱁢  workspace` |

### Package

| Module | Trigger | Shows |
|---|---|---|
| `$package` | `package.json`, `Cargo.toml`, `pyproject.toml`, etc. | `󰏗  1.2.3` |

### Languages (auto-hide per directory)

| Module | Trigger files | Symbol | Color |
|---|---|---|---|
| `$nodejs` | `package.json`, `.nvmrc`, `.node-version` | `` | green pill |
| `$bun` | `bun.lockb` | `` | green pill |
| `$swift` | `*.swift`, `Package.swift` | `` | peach pill |
| `$dart` | `*.dart`, `pubspec.yaml` | `` | blue pill |
| `$rust` | `Cargo.toml` | `` | green pill |
| `$golang` | `go.mod`, `*.go` | `` | green pill |
| `$python` | `*.py`, `pyproject.toml`, `requirements.txt`, `.python-version` | `` | green pill (shows virtualenv name) |
| `$conda` | active conda env | `󰾺 ` | green text |
| `$java` | `*.java`, `pom.xml`, `build.gradle` | ` ` | green pill |
| `$kotlin` | `*.kt`, `build.gradle.kts` | `` | green pill |

### Timing

| Module | Trigger | Shows |
|---|---|---|
| `$cmd_duration` | command took > 2000 ms | `1m 23s` in yellow |
| `$time` | always | `HH:MM` in muted overlay1 color |

---

## Module reference

Full `right_format` order:

```
$git_branch $git_status $docker_context $kubernetes $aws $conda $package
$nodejs $bun $swift $dart $rust $golang $python $java $kotlin $terraform
$cmd_duration $time
```

Global settings:

| Key | Value | Why |
|---|---|---|
| `add_newline` | `false` | no blank line between prompts |
| `command_timeout` | `1000` ms | kills slow modules (git on large repos, cloud CLIs) |
| `palette` | `catppuccin_mocha` | active theme |

---

## Palettes

Two palettes defined in the config:

### `catppuccin_mocha` (active)

Full 26-color Catppuccin Mocha palette. Used across all modules.
Colors referenced by name: `green`, `peach`, `blue`, `mauve`, `lavender`,
`overlay1`, `crust`.

### `neon_cyberpunk`

| Color | Hex | Used for |
|---|---|---|
| `cyan` | `#00F5FF` | vi normal symbol |
| `green` | `#7CFF00` | success, language pills |
| `yellow` | `#FFE600` | git status, duration |
| `red` | `#FF3131` | error symbol |
| `magenta` | `#FF00FF` | Node module |
| `blue` | `#00A3FF` | docker, k8s, lavender mapping |
| `peach` | `#FF6D00` | AWS, terraform, package |
| `mauve` | `#BD00FF` | terraform |

---

## Switching themes

One line change in `starship.toml`:

```toml
# Catppuccin Mocha (default)
palette = 'catppuccin_mocha'

# Neon Cyberpunk
palette = 'neon_cyberpunk'
```

Change takes effect on next prompt render — no shell restart needed.

---

## Testing & debugging

```bash
# Render left prompt in current directory
starship prompt

# Render right prompt
starship prompt --right

# Test a specific module
starship module git_branch
starship module git_status
starship module nodejs
starship module python
starship module kubernetes
starship module aws
starship module docker_context

# Simulate SSH session (shows username@hostname)
SSH_CONNECTION="fake" starship module username
SSH_CONNECTION="fake" starship module hostname

# Measure render time per module
starship timings

# Full prompt explanation (what fired and why)
starship explain
```

`starship explain` is the most useful — lists every active module and the
file/condition that triggered it.

---

## Adding a module

1. Add the module name to `right_format` in the correct position
2. Add a `[module_name]` section with `symbol`, `style`, `format`
3. Follow the language pill pattern for consistency:

```toml
[ruby]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'
```

4. Test with `starship module ruby` in a Ruby project directory
5. Commit

---

## Shell integration

| Shell | Integration file |
|---|---|
| Fish | `conf.d/prompt-starship.fish` — runs `starship init fish` |
| Zsh | `.zshrc` — runs `eval "$(starship init zsh)"` |

Both shells use the same `~/.config/starship/starship.toml`. No per-shell
config needed.
