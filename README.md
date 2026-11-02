## Hyprland / Noctalia

See [desktop installation](docs/hyprland/INSTALL.md) for the active CachyOS setup.
The same config automatically selects the laptop or two-monitor PC layout.

```sh
sh installer/install-hyprland.sh           # Guided questions + recommended new-system choices
sh installer/install-hyprland.sh --minimal # Minimal desktop + saved configs, no setup questions
sh installer/install-apps.sh               # Optional: personal apps + their saved configs
```

The guided installer recommends apps **yes**, replacing configs (with backup)
**yes**, Voxtype **no**, and preview-only **no**. Press Enter to accept each
shown default, then confirm installation. Explicit flags skip the setup dialog.

Use `--with-apps` on the desktop installer to run both in one go. Voxtype is
off by default; enable it explicitly with `--with-voxtype` on a suitable PC.

For a fresh CachyOS install, replace stock configs with your saved settings
(conflicting files are backed up automatically):

```sh
sh installer/install-hyprland.sh --with-apps --replace-configs
```

Already installed the apps? Use `sh installer/install-apps.sh --configs-only`.
For Obsidian, use `sh installer/install-obsidian-config.sh --vault "/path/to/vault"`;
vault settings are never linked into HOME.

## Proton VPN

To get Proton VPN running, we needed to change to `networkmanager`. Thus, the WIFI needs to be reconnected via the cli. Second, we need to login to Proton: 

```bash 
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password password
``` 

```bash 
protonvpn login
```

## Cursor Size On Hyprland

XWayland applications can render oversized cursors on the 1.5-scaled monitors.
Keep the cursor size explicit in both application environments:

- Native applications such as Steam inherit `XCURSOR_SIZE=24` from
  `hyprland/.config/hypr/config/environment.lua`.
- Flatpak applications inherit the same value from the Stow-managed global
  override at `flatpak/.local/share/flatpak/overrides/global`.

After changing either setting, restow its package, reload Hyprland with
`hyprctl reload`, and fully restart the affected applications. Verify the
Flatpak setting with `flatpak override --user --show`.
