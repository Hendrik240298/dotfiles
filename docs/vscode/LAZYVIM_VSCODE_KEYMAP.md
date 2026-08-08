# VS Code LazyVim-Style Setup

This documents the current VS Code setup managed by the `vscode` Stow package.

Config files:

- `vscode/.config/Code/User/settings.json`
- `vscode/.config/Code/User/keybindings.json`

## Philosophy

This is a keyboard-first VS Code setup inspired by Vim/Neovim and LazyVim, not a strict Neovim clone.

The goal is to combine:

- VSCodeVim for modal editing inside text editors.
- Which Key as a discoverable leader-menu overlay and command router.
- Native VS Code keybindings for UI contexts where VSCodeVim does not own input.
- Copilot as an explicit tool, not ambient autocomplete noise.
- VS Code's notebook, preview, sidebar, and editor-group model where it is useful.

The leader key is `Space`. Pressing `Space` should open Which Key instantly in normal-mode/editor and non-editor contexts. After the menu is open, the next key is handled by Which Key, not by VSCodeVim leader remaps.

This design intentionally avoids many direct `Space ...` chords in `keybindings.json`, because those make VS Code wait to decide whether `Space` starts a chord. Instead, `Space` opens Which Key immediately, and Which Key owns the menu.

## Tool Roles

| Tool | Role |
|---|---|
| VSCodeVim | Modal editing, Vim motions, normal-mode LSP/navigation bindings |
| Which Key (`VSpaceCode.whichkey`) | Discoverable leader-menu overlay and leader command execution |
| VS Code keybindings | Open Which Key outside normal editor focus and provide UI/list behavior |
| GitHub Copilot | Manual inline suggestions and chat, not automatic ghost text |
| Jupyter/Notebooks | Notebook commands exposed through the same leader menu |

## Core Settings

| Setting | Value / Purpose |
|---|---|
| `vim.leader` | `<space>` |
| `vim.useSystemClipboard` | Use system clipboard |
| `vim.useCtrlKeys` | Keep Vim control-key behavior enabled |
| `vim.timeoutlen` | `250`, kept low so Vim mappings feel responsive |
| `whichkey.delay` | `0`, show leader menu immediately |
| `whichkey.sortOrder` | `none`, preserve configured menu order |
| `editor.inlineSuggest.enabled` | `true`, required for manual inline suggestions |
| `github.copilot.editor.enableAutoCompletions` | `false`, no automatic Copilot ghost text |
| `github.copilot.nextEditSuggestions.enabled` | `false`, no automatic next-edit suggestions |

## Leader Activation

`Space` opens Which Key in these contexts:

| Context | Behavior |
|---|---|
| Vim normal mode in an editor | Open Which Key |
| Vim visual mode in an editor | Open Which Key |
| Empty editor group | Open Which Key |
| Notebook command mode | Open Which Key |
| Sidebar, auxiliary bar, or panel focus | Open Which Key |
| Markdown preview | Open Which Key |
| Text input / Vim insert mode | Type a literal space |

When Which Key is already open:

| Key | Action |
|---|---|
| `Space` | Trigger the `Space` item in the Which Key menu, currently Quick Open |

## Leader Menu

These mappings are defined in `whichkey.bindings`.

### Root

| Key | Action |
|---|---|
| `<leader><leader>` | Quick Open / fuzzy file search |
| `<leader>/` | Find in current file |
| `<leader>d` | Problems |
| `<leader>e` | Explorer |

### AI

| Key | Action |
|---|---|
| `<leader>ai` | Open chat |

### Buffers

| Key | Action |
|---|---|
| `<leader>bb` | Show all buffers/editors by most recently used |
| `<leader>bn` | New tab / untitled editor |

### Code

| Key | Action |
|---|---|
| `<leader>ca` | Quick fix / code action |

### Files

| Key | Action |
|---|---|
| `<leader>ff` | Find file / Quick Open |
| `<leader>fp` | New Python file |
| `<leader>fm` | New Markdown file |
| `<leader>fs` | New SQL file |
| `<leader>fR` | Rename active file |
| `<leader>fr` | Open Recent |

### Git

| Key | Action |
|---|---|
| `<leader>gg` | Source Control view |
| `<leader>gs` | Stage |
| `<leader>gu` | Unstage |
| `<leader>gS` | Stage all |
| `<leader>gc` | Commit |
| `<leader>gp` | Push |
| `<leader>gl` | Pull |

### Splits And Windows

| Key | Action |
|---|---|
| `<leader>vs` | Vertical split right |
| `<leader>hs` | Horizontal split down |
| `<leader>wv` | Vertical split right |
| `<leader>ws` | Horizontal split down |
| `<leader>ww` | Focus next editor group |
| `<leader>wd` | Close editors in current group |
| `<leader>wS` | Save file |

Notes:

- `v s` and `h s` are kept as direct mnemonic split commands.
- The `w` group keeps the traditional window-management cluster.
- `w d` closes the focused editor group/pane, which is the closest VS Code equivalent to closing the selected split pane.

### Notebook

| Key | Action |
|---|---|
| `<leader>na` | Run all cells |
| `<leader>nr` | Run current cell |
| `<leader>ni` | Interrupt kernel |
| `<leader>nk` | Select kernel |

### Quit / Close

| Key | Action |
|---|---|
| `<leader>qq` | Close VS Code window |
| `<leader>qe` | Close active editor |

### Refactor

| Key | Action |
|---|---|
| `<leader>rn` | Rename symbol |

### Search / SQL

| Key | Action |
|---|---|
| `<leader>ss` | SQL Server Object Explorer |
| `<leader>sq` | New SQL query |
| `<leader>sg` | Find in files |
| `<leader>sc` | Command palette |
| `<leader>sb` | Toggle sidebar |

### UI

| Key | Action |
|---|---|
| `<leader>us` | Toggle sidebar |
| `<leader>uv` | Toggle auxiliary bar |
| `<leader>um` | Toggle menu bar |

## Vim Normal-Mode Bindings

These remain as direct VSCodeVim mappings because they are editor-local Vim-style motions or navigation commands, not leader menu items.

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `[h` | Previous git hunk |
| `]h` | Next git hunk |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<C-h>` | Focus left editor group |
| `<C-j>` | Focus below editor group |
| `<C-k>` | Focus above editor group |
| `<C-l>` | Focus right editor group |

## Native VS Code Keybindings

These are in `keybindings.json`.

### Which Key Entry Points

| Key | When | Action |
|---|---|---|
| `Space` | Vim normal mode | Show Which Key |
| `Space` | Vim visual mode | Show Which Key |
| `Space` | Empty editor group | Show Which Key |
| `Space` | Notebook command mode | Show Which Key |
| `Space` | Sidebar, auxiliary bar, or panel focus | Show Which Key |
| `Space` | Markdown preview | Show Which Key |
| `Space` | Which Key visible | Trigger the `Space` menu item |

### Copilot Manual Trigger

| Key | When | Action |
|---|---|---|
| `Ctrl+Space` | Vim insert mode with Copilot active | Trigger inline suggestion |

Copilot automatic inline completions are disabled. Use `Ctrl+Space` when you explicitly want a suggestion.

### Sidebar And List Behavior

| Key | When | Action |
|---|---|---|
| `Esc` | Sidebar or auxiliary bar focused | Return focus to editor |
| `Ctrl+C` | Sidebar or auxiliary bar focused | Return focus to editor |
| `j` | List focused, not input | Move down |
| `k` | List focused, not input | Move up |
| `h` | List focused, not input | Collapse |
| `l` | List focused, not input | Expand |

### Existing Overrides

| Key | Action |
|---|---|
| `Alt+Right` | Show next inline suggestion |
| `Ctrl+Shift+Enter` | Copilot generate |
| `Ctrl+Enter` | Unbound from Copilot generate |
| `Alt+Escape` | Clear interactive input / quit notebook edit depending on context |

## Maintenance Notes

- Do not add direct `Space ...` chords unless there is a concrete reason. They can reintroduce leader-menu delay.
- Prefer adding leader commands to `whichkey.bindings` in `settings.json`.
- Prefer native `keybindings.json` entries only for contexts where VSCodeVim cannot see the keypress, such as sidebars, panels, notebooks outside cell edit mode, previews, or an empty editor group.
- Keep Copilot manual-first unless explicitly changing the editing philosophy.
- After edits, validate with `python3 -m json.tool vscode/.config/Code/User/settings.json`, validate `keybindings.json` as JSONC, and run `stow -nv vscode`.
