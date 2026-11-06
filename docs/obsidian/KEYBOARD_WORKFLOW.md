# Keyboard-first Obsidian

## Manifesto

- Stay on the keyboard: an operation that requires the mouse is an unresolved gap.
- Prefer conventional Vim motions wherever the current input context permits.
- Tailor ergonomics to Colemak without changing the meanings of `h/j/k/l` or
  interpreting keys by their physical QWERTY positions.

Use built-in Vim mode and Vimrc Support with the existing
[`obsidian/.obsidian.vimrc`](../../obsidian/.obsidian.vimrc).
The opt-in [Hendrik Keyboard adapter](KEYBOARD_ADAPTER.md) fills the native
Explorer and Calendar gaps. No actual vault deployment has been performed.
The mappings below are repository configuration, not proof that a running vault
has loaded it. [Setup and troubleshooting](README.md) remain the reference.

## Change the mental model, not just the shortcuts

1. **Name destinations instead of navigating towards them.** If you know the
   note, use Quick Switcher. If you remember its contents, search the vault.
   The folder tree is for occasional organisation, not the normal way in.
2. **Navigate structure before lines.** Jump by heading, paragraph, link or
   search match. Holding `j` for thirty lines is keyboard-operated scrolling,
   not a better navigation strategy.
3. **Use links as routes and history as your return path.** Follow project/master
   links to go up and related links to go sideways. Go back rather than finding
   the previous note again. Keep your existing `up:`/`x:` convention; no new
   tagging system or vault reorganisation is needed.
4. **Treat Vim as a language.** Combine an action with a target: `ciw` changes
   a word, `ci"` changes quoted text, `yip` copies a paragraph. Prefer these to
   moving, selecting and deleting character by character. Practise on a scratch
   note: Obsidian's CodeMirror Vim is not full Neovim.
5. **Tabs are views, not the notes themselves.** Closing a tab does not delete
   its note. Use a small working set: one writing group and, when useful, one
   reference group. Switching tabs and focusing another group are different
   operations; do not give them the same shortcut.
6. **Know which layer owns the keyboard.** Your desktop switches applications;
   app hotkeys open commands and recover focus; Vim edits text. A dialog or
   sidebar is not a Vim buffer. Use native arrows/Tab/Enter there, including
   your keyboard's navigation layer. Do not remap Colemak or `hjkl` per app.

## The common language with VS Code

These sequences already exist in both repository configurations. Press Escape
in a focused Markdown editor first, then type the sequence; do not hold Space.

| Intent | Keys |
|---|---|
| Find/open a file or note | `Space Space` or `Space ff` |
| Find in the current file | `Space /` |
| Search all files/notes | `Space sg` |
| Command palette | `Space sc` |
| Explorer | `Space e` |
| New Markdown file/note | `Space fm` |
| Rename the active file/note | `Space fR` |
| New tab | `Space bn` |
| Split right / down | `Space wv` / `Space ws` |
| Focus left / down / up / right group | `Ctrl+h/j/k/l` — see conflicts below |
| Toggle left / right sidebar | `Space us` / `Space uv` |
| Close active tab / whole group | `Space qe` / `Space wd` |

### Your required operations

| Operation | Keyboard workflow | Implementation status |
|---|---|---|
| Toggle left/right sidebar | `Space us` / `Space uv` | Existing vimrc |
| Native Explorer | `Space e`, then `j/k`, `h/l`, `l`/Enter, Escape | New local adapter; live check pending |
| Calendar in right sidebar | `Space uc` or `Ctrl+Alt+C`; `h/l` days, `j/k` weeks, `[`/`]` months, `t` today, Enter open, Escape return | New local adapter; live check pending |
| Two side-by-side groups | `Space wv` once; `Space wh/wl` to focus; `gt/gT` for tabs inside a group | Existing vimrc |
| Fuzzy file/note names | `Space Space` or `Space ff` | Native Quick Switcher |
| Search within note / vault | `Space /` or Vim `/`; `Space sg` for the vault | Native editor/core Search |

Split **once**, then use both groups. Repeating the split command creates a
third group; that is not how to switch sides. `Space qe` closes one tab;
`Space wd` closes its entire group. Closing a tab does not delete its note.
Core content search is not a fuzzy full-text engine; no extra search plugin is
required for the stated file-finding/content-search workflow.

Obsidian has no equivalent of your VS Code Which Key menu in this setup.
Learn the small groups (`f` files, `s` search, `w` windows, `u` UI) rather than
trying to remember every sequence at once. Do not add commands just to fill gaps.

### Three native hotkeys worth aligning

The prepared [hotkeys.keyboard.json](hotkeys.keyboard.json) merge fragment
contains these assignments. They are **not deployed automatically**. Merge its
entries into the existing settings or use Obsidian **Settings → Hotkeys**:

| Command | Suggested key | Why |
|---|---|---|
| Quick switcher: Open quick switcher | `Ctrl+P` | VS Code Quick Open |
| Command palette: Open command palette | `Ctrl+Shift+P` | VS Code command palette |
| Search: Search in all files | `Ctrl+Shift+F` | VS Code workspace search |

Change Quick Switcher and Command Palette together: Obsidian normally uses
`Ctrl+P` for the palette. Remove the old conflicting assignment and check the
Hotkeys conflict indicator. Leave `Ctrl+O` available as a Quick Switcher alias
unless you deliberately adopt Vim history later.

Also assign **Focus on last note** (`editor:focus`) to a free app-wide key,
`Alt+E` in the fragment, **after checking conflicts**. This is an Obsidian-specific
escape hatch from sidebars, not a claim of VS Code parity. Escape changes Vim
mode only once the editor actually has focus.

`Ctrl+H` (replace) and `Ctrl+K` (insert link) can intercept your Vim group-focus
bindings. Keep their native text-editing meanings initially and use the existing
Obsidian alternatives `Space wh/wj/wk/wl`. Only reassign native hotkeys if the
directional Ctrl bindings prove more useful; global remaps also affect typing.

Do not replace an existing `hotkeys.json` with a generic template. These few
native changes should preserve the vault's other bindings.

## Within a note: useful Vim, not more Vim

| Need | Keys | Source |
|---|---|---|
| Move by displayed line in wrapped prose | `j` / `k` | Existing vimrc |
| Move by word; find a character | `w`, `b`, `e`; `f{character}`, `;` | Built-in Vim |
| Search and repeat | `/text` Enter, `n` / `N` | Built-in Vim |
| Previous / next paragraph | `{` / `}` | Built-in Vim |
| First / last line | `gg` / `G` | Built-in Vim |
| Change a word / copy a paragraph | `ciw` / `yip` | Built-in Vim + configured clipboard |
| Undo / redo / repeat change | `u` / `Ctrl+R` / `.` | Built-in Vim |
| Previous / next heading | `[[` / `]]` | Vimrc Support |
| Next / previous link; follow it | `gl` / `gL`; `gf` | Vimrc Support |
| Toggle current fold | `za` | Existing vimrc |
| Fold / unfold everything | `zM` / `zR` | Existing vimrc |
| Next / previous tab | `gt` / `gT` | Existing vimrc |
| Outline / backlinks | `Space so` / `Space sl` | Existing vimrc |
| Reveal the active note in Explorer | `Space fe` | Existing vimrc |

Use native **Navigate back/forward** (normally `Alt+Left/Right` on Linux/Windows)
for note history. Verify these in Hotkeys. The vimrc intentionally does not steal
`Ctrl+O/I` from Quick Switcher/italics; enabling those optional Vim mappings also
requires resolving the native conflicts.

Prefer Live Preview while working: Vim owns the text editor, not Reading view.
Use the native **Toggle reading view** command when needed, not a permanent
second interaction model for ordinary writing. To create a link, enter insert
mode, type `[[`, search the target and confirm with Enter.

## A realistic mouse-free loop

1. Focus Obsidian using your existing desktop app/workspace shortcut.
2. Focus the note with your native focus shortcut, then Escape for normal mode.
3. `Space Space` → type part of a title → Enter.
4. `]]` or `/phrase` → navigate to the relevant passage; edit with Vim.
5. `gl` → `gf` to consult a linked note; Navigate back to return.
6. `Space wv` for a reference beside your draft; `Space wh/wl` to change focus.
7. Use the command palette for an infrequent action instead of memorising a key.

For a date-driven detour: `Space uc` → move by day/week/month → Enter. Date
movement itself never creates notes or additional splits. Escape from Calendar
returns to the originating note; Escape from Explorer returns to the last note.

Start with steps 2–4 for a few days. Then add links/history, then split groups.
When you reach for the mouse, identify the missing **operation**: opening a
note, finding a heading, moving focus, or using a particular plugin. Fix that
operation, not the entire interface. Tables, PDF tools, graphs and community
plugin views may have genuine keyboard gaps; more editor mappings cannot repair
them. Add a plugin only for a repeated, specific gap—not for nominal Vim purity.

## Five-minute adoption check

Use a disposable note and layout:

- Type normal spaces in insert mode; Escape then `Space Space` must open notes.
- Confirm `Space /` searches one note and `Space sg` searches the vault.
- Open a sidebar, navigate with arrows, and return with the native focus key.
- Follow a link and go back. Confirm heading motions and clipboard yanking.
- Split two groups with multiple tabs; check focus and tab cycling separately.
- Restart Obsidian and repeat. The presence of a dotfile alone proves nothing.

If a mapped command fails, use the command palette first. See the setup README's
manual checks and `:obcommand` diagnostics before installing another plugin.

## Useful ideas: trials, not default dependencies

### Bookmarks and search priority

Start with the core Bookmarks plugin and a short list of genuinely frequent
notes (project masters, reference indexes). Open its view through the command
palette, and test its native keyboard navigation before adopting it as a daily
route. A bookmark list does **not** establish preferential ranking in the native
Quick Switcher. If boosted search ranking proves valuable, evaluate a switcher
plugin's explicit ranking controls separately; do not install one on speculation.

### Spelling versus autocorrection

Keep native spellcheck and the required English/German dictionaries. This flags
errors; it is **not automatic correction**. Test the keyboard context-menu key
or Shift+F10 and menu navigation on a misspelling in the actual app before
calling correction keyboard-complete. Automatic replacement of actuarial terms,
code, formulas and bilingual notes is risky; no autocorrect/remote language
service has been enabled. Add a narrowly scoped tool only if real errors justify it.

### Advanced Tables: a keyboard-first trial

If Advanced Tables is already installed, start on a disposable note in **Source
mode**, not inside the rendered Live Preview table widget. This avoids confusing
Advanced Tables' raw-Markdown handlers with Obsidian's separate native table UI.

1. Enter Vim insert mode, type `| Heading`, then Tab for the next header.
2. Continue with Tab; Enter starts the first data row.
3. Tab / Shift+Tab moves between cells; Enter advances a row.
4. Escape returns to normal mode for Vim editing. In normal mode, Tab may have
   Vim semantics; do not assume insert-mode table navigation applies there.
5. Use the command palette and search **Advanced Tables** for insert/delete/move
   row/column, alignment and sorting. Those commands avoid the mouse-only controls
   sidebar; add leader bindings only for operations that recur during the trial.

Do not overwrite your existing tab/indent bindings or assume every command works
inside Live Preview's widget. Check a saved Markdown diff after row/column edits;
the plugin itself warns about possible data-loss bugs. No Advanced Tables or
autocorrect plugin was installed, and these optional trials are not claimed tested.

Reference: [Advanced Tables keyboard workflow](https://github.com/tgrosinger/advanced-tables-obsidian#how-to-use).
