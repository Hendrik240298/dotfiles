# Hendrik's Theme

A sharp, dark Obsidian theme for focused technical notes. It pairs readable Fira Sans prose with a compact monospace interface, square pane geometry, and clear active-pane focus.

## Install

The destination is the `.obsidian/themes/` directory inside the vault that should use the theme.

### Linux

From the dotfiles repository root, with `VAULT` set to your vault path:

```sh
stow --simulate --verbose --no-folding --target="$VAULT" obsidian
stow --verbose --no-folding --target="$VAULT" obsidian
```

This installs the theme and selects it via `.obsidian/appearance.json`, alongside
the Vim configuration. Stop on conflicts: compare and back up existing appearance
settings before replacing them with the Stow-managed version. See the
[package instructions](../../README.md). Restart Obsidian after deployment.

### Windows

In PowerShell, from the dotfiles repository root:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\Documents\Obsidian\<vault>\.obsidian\themes"
Copy-Item -Recurse -Force ".\obsidian\.obsidian\themes\Hendrik's Theme" "$env:USERPROFILE\Documents\Obsidian\<vault>\.obsidian\themes\Hendrik's Theme"
```

Restart Obsidian, then select **Hendrik's Theme** under **Settings -> Appearance -> Themes**.

## Update

On Linux, edit the canonical files under `obsidian/.obsidian/themes/Hendrik's Theme/`;
the vault uses those files through Stow links. On Windows, copy the updated files
again. Reload the theme or restart Obsidian.

## Editor spacing regression check

Open `tests/editor-spacing.html` in a browser. The result should report `"passed": true`.
It loads the actual theme and checks that focusing table cells and Kanban cards
does not add bottom padding or change their height, while multiline editing still
grows naturally and main-note/reading-view bottom spacing remains intact. It covers
dark and light modes; resize the window and run `runSpacingTests()` in the console
to check another viewport size.

This is a representative DOM fixture, not a live Obsidian/plugin integration test.
After installing the updated CSS, also focus and blur a table cell and a Kanban
card in Obsidian, including a multiline item, to confirm the installed app's layout.
