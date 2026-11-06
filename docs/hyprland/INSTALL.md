# Hyprland / Noctalia setup

## New machine: guided setup

For Arch/CachyOS, start with an installed system, working graphics/networking,
and a normal user with sudo access. The installer does not partition disks,
install GPU drivers or change the login manager. Clone using HTTPS so SSH keys
are not a prerequisite:

```sh
sudo pacman -Syu --needed git stow
git clone https://github.com/Hendrik240298/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

If the repository is already present, use it rather than cloning over it.
Run as your **normal user**, not `sudo sh`:

```sh
sh installer/install-hyprland.sh
```

With **no flags**, the installer asks short yes/no questions:

| Choice | Shown default | Explanation |
| --- | --- | --- |
| `--with-apps` | **Yes** `[Y/n]` | Recommended on a new system: install the personal app bundle and its saved configs. |
| `--replace-configs` | **Yes** `[Y/n]` | Recommended on a new system: prefer your dotfiles over stock settings, keeping backups. |
| `--with-voxtype` | **No** `[y/N]` | Large model download and GPU setup; leave off on this laptop. |
| `--dry-run` | **No** `[y/N]` | Say yes to preview without changing anything. |

Enter accepts the capitalized default. Invalid answers are asked again. For a
real installation, the script shows your choices and asks for a final
confirmation (`[y/N]`); declining or losing input makes no changes. A preview
does not need that extra confirmation. No-flags mode requires a terminal.

### Explicit flags / minimal base

Providing **any explicit flag** skips these setup questions and retains the
previous opt-in behavior: omitted options stay off. Package managers may still
ask for sudo authentication or package approval. For just the minimal base:

```sh
sh installer/install-hyprland.sh --dry-run # Preview the minimal base without questions
sh installer/install-hyprland.sh --minimal
```

For a fresh CachyOS Hyprland/Noctalia installation, this explicit command
matches the recommended guided choices, skips the setup questions, installs
the desktop and personal app bundle **and replaces stock settings with your
dotfiles**:

```sh
sh installer/install-hyprland.sh --with-apps --replace-configs
```

This needs `paru` (normally present on CachyOS), sudo approval for packages,
and the latest pushed repository. Add `--dry-run` to preview replacements
without installing, moving files, creating backups or linking anything.
Voxtype remains off. This does not copy accounts, SSH keys or Obsidian vaults.

The minimal base needs sudo but **not paru**. It installs:

- Hyprland, Noctalia, UWSM, Hypridle/Hyprlock and Hyprpicker.
- Ghostty, Nautilus, Neovim, Satty, GNOME Calculator and btop.
- Stow, diffutils, jq, wl-clipboard, xhost and the JetBrains Mono Nerd Font.

It Stows `hyprland` (Noctalia, idle/lock configs and launch helpers) and
`ghostty`, and enables `hypridle.service`. It does not install personal apps, HyprMon,
Voxtype, AI models, or every script in `installer/`. Already-installed apps
are left alone; slimming the base does not uninstall anything.

Ghostty's saved config selects the `noctalia` theme. The shared Noctalia config
enables its Ghostty template; the installer applies templates when running in
Hyprland, otherwise the theme is generated when Noctalia starts in that session.

## Optional current personal apps

The bundle is an explicit snapshot of the relevant apps installed on the
laptop in November 2026, **not** a copy of every CachyOS package and not a
dynamic scan of the new machine:

| Apps | Installation |
| --- | --- |
| Code OSS, Obsidian, Super Productivity | Repository packages in `installer/install-apps.sh` |
| Brave | Reuses `installer/install-brave.sh`; sets the default browser |
| Synology Drive | Reuses `installer/install-synology.sh` |
| HyprMon | Reuses `installer/install-hyprmon.sh` |
| Flatpak + Flathub | Reuses `installer/install-flatpak.sh` |
| Python | Reuses `installer/install-python.sh` |

This step requires `paru`. On CachyOS, install it with
`sudo pacman -S --needed paru` if missing; on plain Arch, install the AUR
helper first. Then choose either the combined setup or apps alone:

```sh
sh installer/install-hyprland.sh --dry-run --with-apps
sh installer/install-hyprland.sh --with-apps

# Or add the apps after the minimal desktop is set up:
sh installer/install-apps.sh --dry-run
sh installer/install-apps.sh
```

The small existing AUR/app installers use `--noconfirm`; review them before
running. App accounts and Synology sync jobs still need manual setup.

### Saved configs applied automatically

| Selection | Stow packages / settings |
| --- | --- |
| Base desktop | `hyprland`, `ghostty` |
| Personal app bundle (`--with-apps` or `install-apps.sh`) | `vscode` (VS Code **and** Code OSS settings/keybindings), `flatpak` (global overrides) |
| Optional dictation | `voxtype` |
| Explicit Obsidian vault | `obsidian`, targeted at that vault rather than HOME |

The combined installer checks **all selected home-directory packages** for
conflicts before package installation when Stow is available. The standalone
app installer does the same for `vscode` and `flatpak`. Both check again before
linking. If replacement is not selected, they refuse conflicts. With `--replace-configs`, they compare
and back up conflicting setting files before linking; they never use `--adopt`.

For programs already installed, apply just the saved app configs without sudo,
package downloads, browser-default changes or account setup:

```sh
sh installer/install-apps.sh --configs-only --dry-run
sh installer/install-apps.sh --configs-only

# Prefer the saved app settings over existing defaults, keeping a backup:
sh installer/install-apps.sh --configs-only --replace-configs
```

No saved configs for Brave, Nautilus, Neovim, Satty, Super Productivity,
Synology Drive, Python or HyprMon are currently included beyond the shared
desktop launchers/theme integration. The installer does not invent settings or
copy machine-specific app databases. VS Code extensions are not installed by
Stow; see [VS Code setup](../vscode/LAZYVIM_VSCODE_KEYMAP.md).

All new links use `--no-folding`: directories stay real, with individual files
linked into the repository. Package-local Stow ignore files exclude VS Code
runtime files and Flatpak repositories/state; only the portable settings are
deployed. Existing folded directory symlinks from older installations are not
automatically migrated or deleted; back up their runtime data before any manual
cleanup.

### Obsidian: choose the vault explicitly

The app bundle installs Obsidian but never guesses its vault path or Stows the
`obsidian` package into HOME. After creating/syncing the vault, close Obsidian
and run:

```sh
sh installer/install-obsidian-config.sh --dry-run --vault "$HOME/Obsidian/My Vault"
sh installer/install-obsidian-config.sh --vault "$HOME/Obsidian/My Vault"
```

The vault directory must already exist. This links the Vim configuration,
appearance settings and Hendrik's Theme, stopping on any conflict. Notes,
plugins and other vault settings are not replaced. Vim mode and the Vimrc
Support plugin still need to be enabled manually; see
[Obsidian setup](../obsidian/README.md).

Anki, Calibre, LaTeX, KOReader, Todoist, Portfolio Performance, Ollama and
Voxtype are not in this bundle. Their standalone installers remain available.
Networking/Proton VPN, legacy KDE/i3 helpers and login-manager changes also
remain separate; never run all `install-*.sh` blindly.

## Optional dictation (powerful PC only)

Voxtype is **off by default** on both machines. Answer yes in the guided
dialog or enable it explicitly only if
wanted; it downloads the configured `large-v3` model (about 3 GB), enables GPU
support and starts its user service:

```sh
sh installer/install-hyprland.sh --with-apps --with-voxtype
```

`--without-voxtype` is still accepted for old commands but is no longer
necessary. Skipping Voxtype does not uninstall/stop it if previously set up,
or remove its saved shortcut/Noctalia widget. Those integrations remain
unavailable until dictation is installed; no model or service is set up by
the base or personal-app bundle.

## Shared laptop / PC defaults

The same `hyprland` Stow package is used on both machines. Apps and shortcut
meanings are shared. Display/workspace profiles and per-device keyboard layouts
keep the two machines distinct; never save a laptop's global keyboard state over
the desktop's configuration.

### Automatic laptop / PC detection

By default, detection uses connected DRM display outputs. The first matching
rule wins:

1. **Laptop:** `eDP-1` is connected. This takes priority even when external
   monitors are also connected.
2. **PC:** both `HDMI-A-1` and `DP-1` are connected, without `eDP-1`.
3. **Fallback:** any other combination uses preferred/native resolution,
   100% scaling and no connector-specific workspace pinning.

Detection runs at login and on `hyprctl reload`; no manual profile switching
is needed. After connecting/disconnecting monitors, run `hyprctl reload` to
reselect the profile.

For a mixed/docked setup you can explicitly select `desktop`, `laptop` or `auto`
by putting that single word in `~/.config/hypr/machine`. This file is machine-local,
Git-ignored and excluded from Stow; do not commit it or copy it between machines.
An explicit selection still falls back safely if its required outputs are absent.
It changes display/workspace selection only, never keyboard layouts.

### Saved display profiles

`~/.config/hypr/config/monitor_profiles.lua` contains these profiles:

| Connected outputs | Saved display setup | Workspaces |
| --- | --- | --- |
| `eDP-1` (laptop, takes priority) | **1920×1080 at 60.03 Hz, scale 1.00**, normal orientation at `0x0` | 1–9 on the laptop screen |
| `HDMI-A-1` + `DP-1`, without `eDP-1` (PC) | Preferred/native modes, scale 1.5; HDMI at `1440x560`, DP portrait (`transform = 3`) at `0x0` | 1–8 on HDMI, 9 on DP |
| Other/single-output setup | Preferred/native mode, scale 1.00, automatic positioning | 1–9 without connector pinning |

The laptop profile saves the November 2026 HyprMon setup as the repository
default, rather than relying on a local override. The physical resolution
remains 1920×1080; changing scale from 1.25 to 1.00 gives more usable space.
The PC profile preserves the original dual-monitor layout from commit
`784b698` (also present in the older Omarchy workspace settings):
HDMI-A-1 landscape on the right, DP-1 portrait on the left, workspaces 1–8
on HDMI and 9 on DP. Unknown/additional
outputs use the portable fallback rule in `~/.config/hypr/config/monitors.lua`.

- `~/.config/hypr/config/variables.lua`: shared apps and profile selection.
  Desktop primary-monitor cycling is limited to 1–8, with dedicated workspace 9
  on the portrait display. The laptop has nine primary-monitor workspaces.
- `~/.config/hypr/hyprmon.lua`: optional machine-local override, loaded last
  **only for the laptop profile**, preserving the laptop setup without suddenly
  activating a stale desktop file. It is Git-ignored and excluded from Stow.
- `~/.config/hypr/config/inputs.lua`: global **plain US + US international**, so
  the Q11's firmware Colemak is not remapped again on either machine. Software
  Colemak applies **only** to `at-translated-set-2-keyboard`, the ThinkPad's
  expected built-in keyboard. Verify that exact name with `hyprctl devices` on
  the laptop; if it differs, update that device entry, not the global layout.
  The built-in device resolves shortcuts by the produced symbols, preserving
  the same Colemak letter shortcuts. Caps Lock Compose and Alt+AltGr layout
  switching are retained.

Saved letter shortcuts follow the active layout. `Super+1`–`9` selects a
workspace; adding Shift moves a window there. `Super+Shift+L` locks.

The installer does **not** change the login manager or the console/greeter
keyboard layout. Greeter auto-sync stays disabled until a greeter is set up.
For the optional Noctalia greeter, see [NOCTALIA_GREETER.md](NOCTALIA_GREETER.md).
The laptop's Noctalia layer rendering rule is scoped to the laptop profile;
the desktop retains its existing layer behaviour. Ghostty template generation
is shared; greeter auto-sync is off as a safe shared default.
`arch-installer.sh` is the legacy i3 bootstrap, not the active desktop installer.

## Verify after installation

Before applying shared configuration, run the host-independent regression checks:

```sh
lua docs/hyprland/tests/profiles.lua
```

These capture the real configuration calls for desktop, laptop and fallback:
desktop geometry/workspaces, nine laptop workspaces, no pinning to unknown
outputs, per-device Colemak, and unshadowed workspace shortcuts. They do not
replace verification on the actual laptop.

Log into a Hyprland (UWSM) session, then check:

```sh
hyprctl reload
hyprctl configerrors
hyprctl monitors
hyprctl workspaces
hyprctl devices
noctalia config validate "$HOME/.config/noctalia/config.toml"
systemctl --user status hypridle.service
```

Hypridle should be enabled and active in a graphical session. Its saved config
locks and powers off the display after 10 minutes; activity powers it on again.
It does not automatically suspend. To enable it independently:

```sh
systemctl --user enable --now hypridle.service
```

## Stow conflicts and recovery

### Pulling is deployment when files are Stow-linked

`git pull` can immediately change a running desktop through its existing links.
Stow's conflict checks do not protect files that are already linked. Before
updating either machine:

1. Save local work and record the current commit and working-tree diff.
2. `git fetch origin`, then inspect `git diff HEAD..origin/master -- hyprland`.
3. Reconcile machine-specific changes in profiles/device entries; do not blindly
   pull a laptop's global layout onto a firmware-mapped desktop.
4. Run the regression checks. Prefer an isolated checkout for preparing changes;
   edits to linked source files are live changes too.
5. Fast-forward/merge only after review, dry-run Stow for newly added files,
   then reload and verify keyboards, monitors, workspaces and config errors.

Do not rerun the full installer merely to apply a Git update. A local rollback
of shared files is a recovery measure, not a final reconciliation to commit over
the other machine's work.

When Stow is available, the installer checks for conflicts before installing
packages. Otherwise it checks after installing Stow, before applying configs.
Without `--replace-configs`, it stops rather than overwriting live files.
Compare each conflicting file with the saved version, back it up outside the
Stow package, then move it aside and rerun—or explicitly request replacement.

### Replacing defaults safely

`--replace-configs` is available on `install-hyprland.sh` and `install-apps.sh`,
including together with `--configs-only` or `--dry-run`. It applies to all
selected **home-directory** config packages, not just Noctalia.

The internal `prepare-configs.pl` helper uses Stow's ignore rules to select
only the setting-file paths present in those packages. Before replacing any
file it inspects the complete selection, compares existing regular files with
`diff -u`, then moves conflicts to a unique directory under:

```text
~/.local/state/dotfiles/backups/configs-YYYYMMDD-HHMMSS-XXXXXX/
```

Backups preserve the original relative paths and include `changes.diff`.
Existing correct links are left alone; rerunning does not create needless
backups. Wrong/dangling setting-file symlinks are backed up as links without
changing their destinations. No files are imported into the source repository.

Unrelated files, notes, accounts, app databases and local HyprMon overrides
are not removed. For safety, a directory in place of a setting file, a
non-directory parent or an unrelated directory symlink still causes an error
rather than moving whole directory trees. Obsidian vault deployment remains
separate and does **not** accept this flag.

To restore an old setting, close the affected app, verify that its current
path is a new Stow symlink, remove **only that symlink**, then copy the matching
file from the reported backup path back to its original location. Do not bulk
restore over directories or discard the backups until you have checked the
new installation.

### What `--adopt` actually does

Normal Stow refuses to replace an existing regular file such as
`~/.config/hypr/config/inputs.lua`. With `--adopt`, it instead moves that live
file into `hyprland/.config/hypr/config/inputs.lua`, replacing the repository's
working copy, then links the live path back to it. **It imports the new
machine's settings into the repo; it does not apply or merge your saved settings.**

Git commits are unchanged. Use `git diff -- hyprland` to see the differences
and `git show HEAD:hyprland/.config/hypr/config/inputs.lua` to inspect a saved
version. Back up and review changes before restoring anything: adoption may
have replaced uncommitted work that Git cannot recover. Already-created
symlinks do not mean the saved settings survived adoption.

Before the October 2026 laptop restoration, the current repository configs,
dereferenced live configs and working-tree diff were backed up under
`~/.local/state/dotfiles/backups/20261025-161811/`. Unrelated installer edits
were left untouched.
