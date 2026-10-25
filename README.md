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
