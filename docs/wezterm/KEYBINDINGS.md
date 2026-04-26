# WezTerm Keybindings

This documents the custom keybindings active via `wezterm/.wezterm.lua`.

## Core Setup

- Leader: `Ctrl+Space`
- Pane navigation uses Vim-style `h/j/k/l`.
- Pane splitting uses the `w` window group, matching the VS Code `<leader>w...` convention.
- Tab management uses the `t` tab group.

## Pane Navigation

| Key | Action |
|---|---|
| `Ctrl+Space h` | Focus left pane |
| `Ctrl+Space j` | Focus lower pane |
| `Ctrl+Space k` | Focus upper pane |
| `Ctrl+Space l` | Focus right pane |

## Pane Management

| Key | Action |
|---|---|
| `Ctrl+Space wv` | Split pane right |
| `Ctrl+Space ws` | Split pane down |
| `Ctrl+Space wd` | Close current pane |

## Tab Management

| Key | Action |
|---|---|
| `Ctrl+Space tn` | New tab |
| `Ctrl+Space td` | Close current tab |
| `Ctrl+Space tl` | Next tab |
| `Ctrl+Space th` | Previous tab |
| `Ctrl+Space t1` | Go to tab 1 |
| `Ctrl+Space t2` | Go to tab 2 |
| `Ctrl+Space t3` | Go to tab 3 |
| `Ctrl+Space t4` | Go to tab 4 |
| `Ctrl+Space t5` | Go to tab 5 |
| `Ctrl+Space t6` | Go to tab 6 |
| `Ctrl+Space t7` | Go to tab 7 |
| `Ctrl+Space t8` | Go to tab 8 |
| `Ctrl+Space t9` | Go to tab 9 |

## Disabled Split Defaults

The old number-row split shortcuts are disabled so pane splitting happens through the leader workflow instead.

| Key | Previous Action |
|---|---|
| `Ctrl+Shift+Alt+5` | Split pane right |
| `Ctrl+Shift+Alt+2` | Split pane down |
