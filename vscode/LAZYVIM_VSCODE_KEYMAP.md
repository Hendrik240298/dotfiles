# VS Code LazyVim-Style Keymap (Current Draft)

This documents the custom keybindings currently active via:

- `vscode/settings.json` (`vim.*` mappings handled by VSCodeVim)
- `vscode/keybindings.json` (UI/list behavior outside editor focus)

## Core Vim Setup

- Leader: `Space` (`vim.leader = "<space>"`)
- `Ctrl+P` handled by Vim (`vim.handleKeys["<C-p>"] = true`)
- Clipboard integration enabled (`vim.useSystemClipboard = true`)

## Leader Mappings (Normal Mode)

### Files / Search / Buffers

| Key | Action |
|---|---|
| `<leader><leader>` | Quick Open (file fuzzy search) |
| `<leader>ff` | Quick Open |
| `<leader>fr` | Open Recent |
| `<leader>/` | Find in current file |
| `<leader>sg` | Find in files (project grep) |
| `<leader>bb` | Show editors (MRU) |

### Explorer / SQL / UI / AI

| Key | Action |
|---|---|
| `<leader>e` | Focus Explorer |
| `<leader>s` | Toggle sidebar visibility |
| `<leader>ss` | Focus SQL Server Object Explorer |
| `<leader>sq` | New SQL query |
| `<leader>ai` | Open Copilot Chat |
| `<leader>us` | Toggle sidebar visibility |
| `<leader>ua` | Toggle auxiliary bar |

### Git (SCM)

| Key | Action |
|---|---|
| `<leader>gg` | Focus Source Control view |
| `<leader>gs` | Stage current change |
| `<leader>gu` | Unstage current change |
| `<leader>gS` | Stage all changes |
| `<leader>gc` | Commit |
| `<leader>gp` | Push |
| `<leader>gl` | Pull |

### LSP / Diagnostics / Code Actions

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code action / quick fix |
| `<leader>rn` | Rename symbol |
| `<leader>d` | Open Problems view |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `[h` | Previous git hunk |
| `]h` | Next git hunk |

### Window Management

| Key | Action |
|---|---|
| `<C-h>` | Focus left editor group |
| `<C-j>` | Focus below editor group |
| `<C-k>` | Focus above editor group |
| `<C-l>` | Focus right editor group |
| `<leader>ww` | Focus next editor group |
| `<leader>wd` | Close editors in current group |
| `<leader>w` | Save file |
| `<leader>q` | Close active editor |
| `<leader>qq` | Close VS Code window |

## Non-Editor UI Mappings (`keybindings.json`)

These exist because VSCodeVim mappings do not apply in all UI contexts.

### Sidebar / Auxiliary Bar Control

| Key | When | Action |
|---|---|---|
| `Esc` | Sidebar or auxiliary bar focused | Return focus to editor |
| `Space e` | Sidebar focused | Toggle sidebar |
| `Space s` | Sidebar focused | Toggle sidebar |
| `Space g` | Sidebar focused | Toggle sidebar |
| `Space c` | Sidebar focused | Toggle sidebar |
| `Space c` | Auxiliary bar focused | Toggle auxiliary bar |

### Vim-like List Navigation

| Key | When | Action |
|---|---|---|
| `j` | List focused, not input | Move down |
| `k` | List focused, not input | Move up |
| `h` | List focused, not input | Collapse |
| `l` | List focused, not input | Expand |

## Notes

- This is a VSCodeVim-first setup inspired by LazyVim, not a 1:1 Neovim replica.
- Sidebar/panel behavior is split between `vim.normalModeKeyBindingsNonRecursive` and `keybindings.json` by design.
