# Hendrik Keyboard adapter

Status: **prepared and fixture-tested; not deployed or verified in a real vault**.
Source: `obsidian/.obsidian/plugins/hendrik-keyboard/`.

## Deliberately small scope

Built-in Vim + Vimrc Support remain the editor. This adapter fills only two UI
gaps; it is not another Vim implementation or app-wide leader engine.

- Native File Explorer: `h/j/k/l` delegate to its existing tree handlers;
  `l` opens a focused file, Enter stays native, Escape focuses the last note.
- Liam Cain's Calendar: a reliable focus command, visible selected date,
  `h/l` ±1 day, `j/k` ±1 week, `[`/`]` ±1 month, `t` today, Enter opens the day,
  Escape returns to the note from which Calendar was entered.
- The focus command reveals an existing Calendar, expanding its sidebar, or
  recreates a closed Calendar in the right sidebar. Default global hotkey:
  `Ctrl+Alt+C` on Linux/Windows; editor leader alias: `Space uc`.
- Date movement only changes selection/display. **Only Enter** calls Calendar's
  own open/create function, preserving its Daily Notes/Periodic Notes settings,
  templates and confirmation behaviour. It never requests a new split.

All letter handling uses `KeyboardEvent.key`, **not physical `code` values**.
That preserves conventional Vim letters with firmware Colemak and software
Colemak. There is no QWERTY-position remap, fixed-layout option or firmware change.
Renaming/text inputs, IME, modified keys, menus and modal dialogs are left alone.
There are no deletion/rename commands, filesystem scans, network requests,
shell commands, runtime dependencies or configurable JavaScript snippets.

## Install later, explicitly

The regular `obsidian` Stow package now includes the adapter's three files.
Stow links the files but **does not enable the plugin**, install Calendar, or
alter `community-plugins.json`. Existing conflicting plugin files stop deployment.

On Windows, copy `main.js`, `manifest.json` and `styles.css` into
`<vault>/.obsidian/plugins/hendrik-keyboard/`, preserving existing files.
Enable **Hendrik Keyboard** and the existing **Calendar** plugin through
Obsidian's settings after deployment. Do not enable a second Explorer keyboard
plugin at the same time. Vimrc Support's **Support JS Commands stays off**.

`hotkeys.keyboard.json` is a separate merge fragment, **not** a complete vault
configuration. Merge its entries or set them in Settings → Hotkeys; never copy
it over an existing hotkeys file. Check conflicts first.

## Compatibility boundary

This prototype uses undocumented interfaces in two small, explicit places:

1. Native Explorer's `tree.onKeyArrow*`, `tree.focusedItem` and `onKeyOpen`.
2. Calendar view's `calendar.$set({displayedMonth})`, `.day` markup, and
   `openOrCreateDailyNote(date, false)`.

The plugin also checks Calendar's loaded-plugin entry. These are not guaranteed
public APIs. Missing method interfaces produce a notice instead of guessing note
paths or silently substituting another action. Calendar uses Svelte rendering;
the adapter waits a microtask before highlighting the selected day. Its cursor
outline is independent of Calendar's active-note highlight.

The fixture mocks these interfaces; it cannot prove that the installed versions
match. Main application window only; popout windows are not supported yet.
If something fails, disable the adapter, keep using native commands/arrows, and
check compatibility before changing its scope.

### Why not Sidebar Keyboard Navigation?

The inspected upstream `main.ts` and key mappers handle `event.code` rather than
semantic letters. Its own README warns that mappings reflect QWERTY. That is not
the desired common Colemak behaviour, especially on the software-mapped laptop.
This adapter retains only the minimal movement/open/focus bridge, not that
plugin's broader file-management feature set.

Source references checked 2026-11-06:

- [Calendar view implementation](https://github.com/liamcain/obsidian-calendar-plugin/blob/master/src/view.ts)
- [Calendar commands](https://github.com/liamcain/obsidian-calendar-plugin/blob/master/src/main.ts)
- [Calendar day markup](https://github.com/liamcain/obsidian-calendar-ui/blob/master/src/components/Day.svelte)
- [Sidebar Keyboard Navigation key handling](https://github.com/denvolok/obsidian-sidebar-keyboard-navigation/blob/9939a041560cf3d768805e09d5582e01e9a7652b/src/main.ts)
- [Native Explorer handler interface reference](https://github.com/denvolok/obsidian-sidebar-keyboard-navigation/blob/9939a041560cf3d768805e09d5582e01e9a7652b/src/views/file-explorer/FileExplorerActions.ts)

## Verification

From the dotfiles root on Linux with Firefox installed:

```sh
python3 docs/obsidian/tests/run-browser-tests.py
```

This runs spacing, heading and keyboard-adapter DOM fixtures in an isolated
headless Firefox profile. It never opens the actual vault. The keyboard fixture
covers semantic Colemak keys, Explorer delegation, protected inputs/dialogs,
Calendar focus, date/week/month/year boundaries, leap years, Enter delegation,
no extra splits, Escape, missing interfaces and unload cleanup.

Before adoption in a disposable vault/layout:

1. Check `Space e`, Explorer `hjkl`, `l`/Enter, Escape, and rename input safety.
2. Test with the Q11 on the desktop and the actual laptop built-in keyboard.
3. Collapse the right sidebar: `Ctrl+Alt+C` must reveal/focus Calendar. Repeat
   while it already exists, and after closing the widget.
4. Move between days/weeks/months without opening notes. Cross a month/year
   boundary and verify the cursor outline, date label and displayed month agree.
5. Enter opens the selected day using the existing note settings, without
   creating another split. Test missing-day creation/confirmation separately.
6. Escape returns focus to the expected note. Dialogs and text inputs must keep
   their normal keyboard behaviour.
7. Disable the adapter: its outline/help disappears and native UI remains usable.
