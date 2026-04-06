# Dotfiles Agent Notes

## Repo Shape
- This repo is a GNU Stow repo, not an app/library repo. There is no build, test, lint, CI, or root manifest to rely on.
- Current Stow packages: `i3`, `polybar`, `dunst`, `rofi`, `wezterm`, `protonvpn`, `vscode`.
- Non-package repo items that should stay out of Stow package roots: `docs/`, `ubuntu-settings.sh`, `arch-installer.sh`, `arch-settings.sh`, `install_yay.sh`, `background.jpg`.

## Stow Rules
- Keep package roots clean. Any extra file at a package root will be linked into `$HOME` by Stow. This already bit `vscode`; docs belong under `docs/`, not inside a package root.
- Inside configs and scripts, use target paths like `~/.config/...` or `$HOME/...`, not repo paths like `~/dotfiles/...`.
- Before assuming a package is broken, check for existing non-symlink target files in `$HOME`; Stow aborts on those conflicts.
- Safe repo-wide dry-run: `stow -nv i3 polybar dunst rofi wezterm protonvpn vscode`

## Verification
- The main verification for repo changes is Stow + syntax checks, not tests.
- Validate i3 config with: `i3 -C -c /home/hendrik/dotfiles/i3/.config/i3/config`
- Validate edited shell scripts with `sh -n <script>`.
- If a live file blocks Stow and it should be Stow-managed, compare first with `diff -u <repo-file> <live-file>` before replacing it with a symlink.

## Runtime Coupling
- `i3/.config/i3/config` hardcodes a dual-monitor layout: workspaces are pinned to `HDMI-0` / `DP-0`, and startup runs `xrandr` to force both outputs to `2560x1440`. Treat workspace bindings and the `xrandr` line as a coupled change.
- i3 starts Polybar via `~/.config/polybar/launch.sh`; if bar startup breaks, check that path first.
- i3 wallpaper startup uses `$HOME/Pictures/background.jpg`. The repo root `background.jpg` is not referenced by the active config.
- `polybar/.config/polybar/config.ini` defaults Wi-Fi to `wlp6s0` unless `POLYBAR_WLAN` is set in the environment.

## Setup Scripts
- `ubuntu-settings.sh` only sets XDG MIME defaults for PDF, image, and browser handlers.
- `arch-installer.sh`, `arch-settings.sh`, and `install_yay.sh` are Arch-specific bootstrap helpers; do not treat them as current Ubuntu setup steps.
