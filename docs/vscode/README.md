# VS Code Dotfiles

This package manages Hendrik's VS Code user settings and keybindings.

The setup combines VSCodeVim, Which Key, native VS Code keybindings, GitHub Copilot, Jupyter notebooks, and Markdown preview behavior into one keyboard-first workflow.

Read `docs/vscode/LAZYVIM_VSCODE_KEYMAP.md` before changing the VS Code config. It documents the current leader-menu architecture, keybindings, and maintenance rules.

## Setup

`stow vscode`

## Verify

`ls -l ~/.config/Code/User/settings.json ~/.config/Code/User/keybindings.json`

For a dry run before applying links:

`stow -nv vscode`
