# VS Code LazyVim-Style Keymap (Current Draft)

This documents the custom keybindings currently active via:

- `vscode/.config/Code/User/settings.json` (`vim.*` mappings handled by VSCodeVim)
- `vscode/.config/Code/User/keybindings.json` (UI/list behavior outside editor focus)

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
| `<leader>sc` | Command Palette / Commands |
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
| `<leader>uv` | Toggle auxiliary bar |
| `<leader>um` | Toggle menu bar |

### Notebook

| Key | Action |
|---|---|
| `<leader>na` | Run all notebook cells |
| `<leader>nr` | Run current notebook cell |
| `<leader>ni` | Interrupt notebook kernel |
| `<leader>nk` | Open notebook kernel picker |

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
| `<leader>wv` | Split editor right |
| `<leader>ws` | Split editor down |
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
| `Ctrl+C` | Sidebar or auxiliary bar focused | Return focus to editor |
| `Space ...` | Empty editor group focused | Use leader-style chords without VSCodeVim editor focus |
| `Space Space` | Empty editor group focused | Quick Open |
| `Space ff` | Empty editor group focused | Quick Open |
| `Space fr` | Empty editor group focused | Open Recent |
| `Space s` | Empty editor group focused | Toggle sidebar visibility |
| `Space ss` | Empty editor group focused | Focus SQL Server Object Explorer |
| `Space sq` | Empty editor group focused | New SQL query |
| `Space sg` | Empty editor group focused | Find in files |
| `Space sc` | Empty editor group focused | Command Palette / Commands |
| `Space bb` | Empty editor group focused | Show editors (MRU) |
| `Space e` | Empty editor group focused | Focus Explorer |
| `Space gg` | Empty editor group focused | Focus Source Control view |
| `Space ai` | Empty editor group focused | Open Copilot Chat |
| `Space us` | Empty editor group focused | Toggle sidebar visibility |
| `Space uv` | Empty editor group focused | Toggle auxiliary bar |
| `Space um` | Empty editor group focused | Toggle menu bar |
| `Space d` | Empty editor group focused | Open Problems view |
| `Space qq` | Empty editor group focused | Close VS Code window |
| `Space wv` | Empty editor group focused | Split editor right |
| `Space ws` | Empty editor group focused | Split editor down |
| `Space e` | Sidebar focused | Toggle sidebar |
| `Space s` | Sidebar focused | Toggle sidebar |
| `Space g` | Sidebar focused | Toggle sidebar |
| `Space c` | Sidebar focused | Toggle sidebar |
| `Space c` | Auxiliary bar focused | Toggle auxiliary bar |
| `Space na` | Notebook command mode | Run all notebook cells |
| `Space nr` | Notebook command mode | Run current notebook cell |
| `Space ni` | Notebook command mode | Interrupt notebook kernel |
| `Space nk` | Notebook command mode | Open notebook kernel picker |

### Vim-like List Navigation

| Key | When | Action |
|---|---|---|
| `j` | List focused, not input | Move down |
| `k` | List focused, not input | Move up |
| `h` | List focused, not input | Collapse |
| `l` | List focused, not input | Expand |

## Notes

- This is a VSCodeVim-first setup inspired by LazyVim, not a 1:1 Neovim replica.
- Sidebar/panel and empty-editor behavior are split between `vim.normalModeKeyBindingsNonRecursive` and `keybindings.json` by design, because VSCodeVim only owns key handling while an editor is active.
- Notebook leader behavior is split the same way: `vim.normalModeKeyBindingsNonRecursive` covers a cell editor in normal mode, while `keybindings.json` covers notebook command mode (`Esc` out of the cell, then use the same chord).
