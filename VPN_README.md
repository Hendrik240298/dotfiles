# VPN Setup

This setup uses Proton VPN WireGuard configs with NetworkManager.

## ProtonVPN CLI Cleanup

Remove the ProtonVPN CLI if it is still installed:

```sh
sudo pacman -Rns proton-vpn-cli
```

Custom ProtonVPN autostart units were removed from:

```sh
~/.config/systemd/user/protonvpn.service
~/.config/systemd/user/protonvpn.timer
```

Old broken keyring files were moved to:

```sh
~/.local/share/keyrings-protonvpn-backup-1777380600/
```

NetworkManager remains enabled and active.

## Generate WireGuard Config

1. Open Proton VPN downloads: https://account.protonvpn.com/downloads
2. Generate a WireGuard config for GNU/Linux.
3. Recommended options:
   - NetShield: malware blocking only
   - Moderate NAT: off
   - NAT-PMP / port forwarding: off
   - VPN Accelerator: on
4. Download the `.conf` file to `~/Downloads`.

Do not share the file contents. It contains a private key.

## Import Into NetworkManager

Replace the filename with the downloaded config name:

```sh
sudo nmcli connection import type wireguard file ~/Downloads/protonvpn-de.conf
```

List connections:

```sh
nmcli connection show
```

Optionally rename the imported connection:

```sh
sudo nmcli connection modify "old-name" connection.id protonvpn-de
```

Delete the downloaded config after import:

```sh
rm ~/Downloads/protonvpn-de.conf
```

## Use The VPN

Connect:

```sh
sudo nmcli connection up protonvpn-de
```

Disconnect:

```sh
sudo nmcli connection down protonvpn-de
```

Check active connections:

```sh
nmcli connection show --active
```

Check public IP:

```sh
curl https://ifconfig.me
```

## Autostart

The imported WireGuard connection has `connection.autoconnect yes` by default.

Check it:

```sh
nmcli connection show protonvpn-de | grep connection.autoconnect
```

Disable autostart if you want manual switching between multiple WireGuard profiles:

```sh
sudo nmcli connection modify protonvpn-de connection.autoconnect no
```
