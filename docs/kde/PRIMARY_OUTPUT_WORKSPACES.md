# Primary Output Workspaces

`Primary Output Workspaces` is a local KWin script for a two-monitor Plasma 6.7+ setup.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| `Meta+1` through `Meta+9` | Switch the primary output to that desktop |
| `Meta+Shift+1` through `Meta+Shift+9` | Move the active window to that desktop on the primary output |
| `Meta+0` | Switch the secondary output to desktop 1 and focus it |
| `Meta+Shift+0` | Move the active window to desktop 1 on the secondary output |

KGlobalAccel stores the shifted number-row bindings by their US-layout symbols (`Meta+!` through `Meta+)`), which correspond to the `Meta+Shift+number` key presses.

The script uses Plasma's output order: index 0 is the primary output and index 1 is the secondary output.

When a target desktop has no normal window to activate, the script falls back to KWin's native screen-switch action. This focuses the desktop surface and marks the otherwise empty output active.

## Setup

1. Run `stow kde` from the dotfiles repository.
2. Open **System Settings -> Window Management -> Virtual Desktops**.
3. Enable **Switch desktops independently for each screen**.
4. Open **System Settings -> Window Management -> KWin Scripts**.
5. Enable **Primary Output Workspaces**.
6. Disable **Virtual Desktops Only on Primary**; it makes secondary-output windows sticky and conflicts with this script's explicit desktop assignments.
7. Under **System Settings -> Keyboard -> Shortcuts -> KWin**, remove existing `Meta+number` bindings from **Switch to Desktop N** and **Window to Desktop N** so the script can claim them.

Re-enable the KWin script or log out and back in after changing its files.
