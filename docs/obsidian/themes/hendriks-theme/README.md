# Hendrik's Theme

A sharp, dark Obsidian theme for focused technical notes. It pairs readable Fira Sans prose with a compact monospace interface, square pane geometry, and clear active-pane focus.

## Install

The destination is the `.obsidian/themes/` directory inside the vault that should use the theme.

### Linux

```bash
mkdir -p "$VAULT/.obsidian/themes"
cp -r /path/to/hendriks-theme "$VAULT/.obsidian/themes/Hendrik's Theme"
```

### Windows

In PowerShell:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\Documents\Obsidian\<vault>\.obsidian\themes"
Copy-Item -Recurse -Force "C:\path\to\hendriks-theme" "$env:USERPROFILE\Documents\Obsidian\<vault>\.obsidian\themes\Hendrik's Theme"
```

Restart Obsidian, then select **Hendrik's Theme** under **Settings -> Appearance -> Themes**.

## Update

Replace `theme.css` and `manifest.json` in the installed theme directory, then reload the theme or restart Obsidian.
