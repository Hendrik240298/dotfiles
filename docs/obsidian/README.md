# Obsidian: VS Code / LazyVim-style normal-mode navigation

## Decision

Use Obsidian's built-in Vim mode plus **Vimrc Support** (`obsidian-vimrc-support`).
Keep the native Quick Switcher, native File Explorer, and existing sidebar views.
The Markdown editor in normal mode is the command centre. Do not add an app-wide
leader plugin or replace the explorer just to make Space work elsewhere.

The canonical configuration is `../../obsidian/.obsidian.vimrc`, managed by the
`obsidian` Stow package with an explicit vault-root target. It has not been
smoke-tested in a running vault. The canonical VS Code reference
is `../vscode/LAZYVIM_VSCODE_KEYMAP.md`; the principle is **same intent, same keys**.
Do not imitate programming-specific features in Markdown or give an existing key
a different meaning just to fill every slot.

## Installation: Windows and Linux

1. Leave **Settings → Editor → Vim key bindings** enabled.
2. Install and enable **Vimrc Support** from Community plugins.
3. On Linux, use the targeted Stow commands below. Stop on conflicts; do not
   overwrite existing files or use `--adopt` to import vault contents.
4. On Windows, copy `obsidian/.obsidian.vimrc` from this repository to
   `<vault>/.obsidian.vimrc` (the vault root, **not** `.obsidian/`), preserving
   any existing configuration. The plugin also allows a custom vault-relative path.
5. Restart Obsidian after changing the file and run the manual checks below.

The file has no OS-specific paths, shell commands, or JavaScript snippets.
Leave **Support JS Commands** disabled. Configure each vault/device as needed;
do not assume your sync mechanism transfers hidden root files automatically.

### Targeted Stow deployment on Linux

Run from the dotfiles repository root:

```sh
stow --simulate --verbose --no-folding --target="$HOME/Obsidian" obsidian
stow --verbose --no-folding --target="$HOME/Obsidian" obsidian
```

**Always specify the vault target for this package.** It is not a regular
home-target package and must not be included in bulk `stow -t "$HOME"` commands.
The package contains only `.obsidian.vimrc`; documentation stays under `docs/`.
Stow creates that single file link, not a link replacing the vault directory.
No notes, vault settings, plugins, or native hotkeys are managed by this package.

The config uses literal `<Space>` sequences and `<CR>` terminators. Do not add
`let mapleader`: the installed plugin reported "Not an editor command" for it.
Upstream's current README describes leader expansion, but that does not establish
support in the installed release. Literal Space mappings keep the same shortcuts
without relying on that feature.

## Shared key meanings

`Space` is the leader. Sequences are typed consecutively in normal mode.

| Keys | Obsidian action | Relationship to VS Code |
|---|---|---|
| `Space Space`, `Space ff` | Native Quick Switcher | Quick Open / find file |
| `Space /` | Search current note | Find in file; not vault search |
| `Space e` | Show File Explorer | Explorer |
| `Space bn` | New tab | New tab |
| `Space fm` | New Markdown note | New Markdown file; Obsidian creates a file immediately |
| `Space fR` | Rename active note | Rename active file; not symbol rename |
| `Space sg` | Search the vault | Find in files |
| `Space sc` | Command palette | Command palette |
| `Space sb`, `Space us` | Toggle left sidebar | Toggle main sidebar |
| `Space uv` | Toggle right sidebar | Toggle auxiliary sidebar |
| `Space wv`, `Space vs` | Split right | Vertical split |
| `Space ws`, `Space hs` | Split down | Horizontal split |
| `Ctrl+h/j/k/l` | Focus left/below/above/right group | Same directional focus |
| `Space wd` | Close current tab group | Close editors in current group; distinct from closing one tab |
| `Space wS` | Save current note | Save file; Obsidian also autosaves |
| `Space qe` | Close current tab | Close active editor |
| `Space qq` | Close current Obsidian window | Close app window; not necessarily quit all windows |

## Obsidian additions

These do not replace existing VS Code meanings:

| Keys | Action |
|---|---|
| `Space fe` | Reveal active note in File Explorer |
| `Space wh/wj/wk/wl` | Directional group focus without Ctrl hotkey conflicts |
| `gt`, `gT` | Next / previous tab |
| `Space so` | Show Outline |
| `Space sl` | Show Backlinks |
| `Space sx` | Show Outgoing links |
| `Space sp` | Show current note's Properties view |
| `Space ug` | Open graph |
| `Space uc` | Calendar, only if its commented mapping is enabled and Calendar is already installed |
| `za`, `zM`, `zR` | Toggle current fold / fold all / unfold all |

Vimrc Support supplies heading motions `[[`/`]]`, link motions `gl`/`gL`, and
`gf` for following a link. The configuration uses visual-line `j`/`k` for wrapped prose
and the system clipboard. Keep `Ctrl+O` as native Quick Switcher for now.

## Sidebar → editor loop

Vimrc mappings do not work in the File Explorer, Outline, search inputs, or
Reading view. Native sidebar keyboard navigation is intentionally retained:

1. From the note, press `Space fe` to reveal it, or `Space e` to show Explorer.
2. Use arrow keys to browse the tree, Left/Right to collapse/expand, and Enter
   to open a note. Depending on focus, Tab may be needed to enter the tree.
3. Use Escape where the current Obsidian version returns to the editor.
   For a predictable fallback, assign the native **Focus on last note** command
   (`editor:focus`) to a free global shortcut, e.g. `Ctrl+Shift+E` after checking
   existing bindings. The vimrc cannot intercept Escape outside the editor.
4. Once back in a Markdown editor, press Escape to reach normal mode and use
   the leader sequences again.

Before relying on the direct `Ctrl+h/j/k/l` Vim mappings, review native hotkeys.
`Ctrl+H` commonly means search/replace and `Ctrl+K` means insert link. Native
hotkeys can intercept these before Vim. Either remove/reassign the conflicts,
or use the leader-direction alternatives. Global directional hotkeys can also
be assigned through Obsidian's Hotkeys settings if wanted outside normal mode,
but they will then also apply while typing; this is not a scoped Vim mapping.

## Honest parity gaps

- **Which Key menu:** Space sequences work, but Vimrc Support does not provide
  VS Code's immediate, grouped command menu. Its chord/status display is not
  the same feature.
- **`Space bb`:** reserved for an open-tab/buffer picker. A vault-wide search is
  not equivalent; the misleading old alias was removed. Use native tab cycling
  for now. A real picker would require another plugin or a JS helper.
- **`Space ww`:** reserved for cycling tab groups, not tabs. Core directional
  focus works, but no core cycle-group command was verified. A small JS helper
  is possible with Vimrc Support's opt-in JS feature; it is not enabled here.
- **`Space fr`:** reserved for recent-file navigation, not reveal-file. An empty
  native Quick Switcher query shows recent notes, but no separate core recent
  picker command was verified.
- **Move a tab to another group:** not the same as splitting/duplicating a note.
  The focused **Move Tab to Group** plugin offers actual left/right moves, but
  uses internal APIs. It is not installed or required by this configuration.
- **Keyboard pane resizing:** no native resize command was verified. Obsidian's
  documentation describes dragging the divider. A JS helper could use internal
  layout APIs, but adds security/compatibility costs; leave this explicit rather
  than masquerading zoom or split commands as resizing.
- **Explorer `hjkl`:** native arrows only; actual `hjkl` would need additional
  explorer handling. Editor `nmap` cannot change sidebar behaviour.
- **Code/LSP, diagnostics, notebooks, SQL and AI:** not mapped without a genuine
  Markdown equivalent or an existing plugin. Git actions require a Git plugin.
- **`zo`/`zc`:** not mapped to a toggle, because explicit open/close and toggling
  have different meanings.

Keep this first version to one plugin. Revisit the gaps after using it rather
than enabling arbitrary JS or adding plugins purely for nominal parity.

## Manual checks before adopting

Test on a disposable note/layout on both Windows and Linux:

1. Type spaces in insert mode: ordinary typing must remain unchanged. In normal
   mode, `Space Space` and `Space ff` must open the native Quick Switcher.
2. `Space /` must search the current note; `Space sg` must search the vault.
3. Create right/down splits. Test directional focus with two notes and multiple
   tabs in each group. `gt` changes tabs; directional focus changes groups.
4. `Space qe` closes one tab. `Space wd` closes the whole group. `Space qq` closes
   the current window: test these only after saving and with a disposable layout.
5. Reveal a nested note with `Space fe`, browse using arrows, and return using
   the configured native focus shortcut. Check normal mode before using Space.
6. Test sidebar toggles and enabled Outline/Backlinks/Outgoing links/Properties
   views; opening a view is not a promise that every view supports keyboard use.
7. Verify `Space fm`, `Space fR`, clipboard yanking, wrapped-line `j`/`k`, `za`,
   `zM`, `zR`, and plugin-provided heading/link motions.
8. Restart Obsidian and repeat a few mappings to confirm configuration loading.

If a command does not work, try `:obcommand <command-id>` in the editor first.
Typing `:obcommand` without an ID prints the installed command list to the
developer console. Command availability depends on the Obsidian version and
enabled core/community plugins; failures can otherwise be silent.

## Simon Späti: confirmed reference

Checked on 2026-10-06:

- His [Obsidian note](https://www.ssp.sh/brain/obsidian/#vim-mode) explicitly says
  he uses Vim motions in Obsidian while keeping its note-taking environment.
- His [Vimrc explanation](https://www.ssp.sh/brain/vimrc-for-obsidian/) shows
  `exmap … obcommand …` followed by `nmap <Space>… :…<CR>`: the same approach here.
- His [public plugin list](https://github.com/sspaeti/dotfiles/blob/master/obsidian/Simon/SecondBrain/.obsidian/community-plugins.json)
  includes `obsidian-vimrc-support`.
- His [current public vimrc](https://github.com/sspaeti/dotfiles/blob/master/obsidian/Simon/SecondBrain/.obsidian/.vimrc)
  includes wrapped-line motions, clipboard support, Space-based search/Outline,
  fold commands, and a zen toggle combining Hider and the right-sidebar command.
- His actual bindings differ: `Space Space` opens Todos, `Space O` opens Quick
  Switcher, and `Space f` invokes Omnisearch. Borrow the method, not those keys
  or his larger plugin stack. His older published vimrc link is now stale.

Further references:

- [Vimrc Support README](https://github.com/esm7/obsidian-vimrc-support)
- [Obsidian tabs: movement and resizing](https://help.obsidian.md/tabs)
- [Move Tab to Group](https://github.com/hanchanghun/move-tab-to-group)

Vimrc Support's README currently requests a maintainer; its age and adoption are
useful evidence, not a guarantee against future Obsidian changes.
