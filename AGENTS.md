# Dotfiles Agent Notes

## Repo Shape
- This repo is a GNU Stow repo, not an app/library repo. There is no build, test, lint, CI, or root manifest to rely on.
- Current Stow packages in this repo include `dunst`, `i3`, `omarchy`, `polybar`, `protonvpn`, `rofi`, `voxtype`, `vscode`, `wallpaper`, and `wezterm`.
- The active desktop/session is Omarchy only. Treat `omarchy/` as the current desktop config, and treat `i3/` and `polybar/` as legacy unless the user explicitly asks to work on them.
- Non-package repo items that should stay out of Stow package roots: `docs/`, `ubuntu-settings.sh`, `arch-installer.sh`, `arch-settings.sh`, `install_yay.sh`, `background.jpg`.

## Stow Rules
- Keep package roots clean. Any extra file at a package root will be linked into `$HOME` by Stow. This already bit `vscode`; docs belong under `docs/`, not inside a package root.
- Inside configs and scripts, use target paths like `~/.config/...` or `$HOME/...`, not repo paths like `~/dotfiles/...`.
- Before assuming a package is broken, check for existing non-symlink target files in `$HOME`; Stow aborts on those conflicts.
- Safe repo-wide dry-run: `stow -nv dunst i3 omarchy ollama polybar protonvpn rofi voxtype vscode wallpaper wezterm`

## Verification
- The main verification for repo changes is Stow + syntax checks, not tests.
- For Omarchy/Hyprland changes, validate with: `hyprctl reload` and then `hyprctl configerrors`.
- Validate legacy i3 config changes with: `i3 -C -c /home/hendrik/dotfiles/i3/.config/i3/config`
- Validate edited shell scripts with `sh -n <script>`.
- If a live file blocks Stow and it should be Stow-managed, compare first with `diff -u <repo-file> <live-file>` before replacing it with a symlink.

## Runtime Coupling
- Omarchy is the active desktop environment on this machine. Do not assume i3 or Polybar changes affect the live session unless the user says they still use those legacy configs.
- `omarchy/` contains the current Omarchy-specific overrides tracked by this repo.
- For any VS Code related work, read `docs/vscode/LAZYVIM_VSCODE_KEYMAP.md` first for the current keymap architecture and maintenance rules.
- `i3/.config/i3/config` hardcodes a dual-monitor layout: workspaces are pinned to `HDMI-0` / `DP-0`, and startup runs `xrandr` to force both outputs to `2560x1440`. Treat workspace bindings and the `xrandr` line as a coupled change when editing the legacy i3 setup.
- Legacy i3 starts Polybar via `~/.config/polybar/launch.sh`; if bar startup breaks, check that path first.
- i3 wallpaper startup uses `$HOME/Pictures/background.jpg`. The repo root `background.jpg` is not referenced by the active config.
- `polybar/.config/polybar/config.ini` defaults Wi-Fi to `wlp6s0` unless `POLYBAR_WLAN` is set in the environment.

## Setup Scripts
- `installer/install-ollama.sh` restows the `ollama` package, reloads the user systemd manager, enables the user `ollama.service`, and enables linger so it starts at boot.
- `ubuntu-settings.sh` only sets XDG MIME defaults for PDF, image, and browser handlers.
- `arch-installer.sh`, `arch-settings.sh`, and `install_yay.sh` are Arch-specific bootstrap helpers; do not treat them as current Ubuntu setup steps.
