# Noctalia Greeter

## Purpose

Noctalia Greeter is the graphical `greetd` login screen for the daily
Hyprland/Noctalia session. It replaces the generic SDDM Maya fallback with a
login screen designed to share Noctalia's visual language and support its
appearance sync.

## When To Use It

Use this setup on CachyOS when Hyprland with Noctalia is the primary desktop
session. It is especially appropriate after removing Plasma Login or SDDM and
when a keyboard-first Wayland workflow is the intended daily environment.

The greeter is independent of the desktop session: it can offer other
installed Wayland sessions, such as GNOME, as fallback choices. It does not
install those desktops itself.

Do not use this setup for a KDE Plasma-first system, where SDDM is the native
and simpler choice, or for a GNOME-first system, where GDM is the supported
default. It is also unnecessary on a headless or server system without a
graphical login.

On other Arch-based distributions the same greeter is available through the
AUR. This repository's installer is specific to CachyOS/Arch because it uses
`pacman` and systemd.

## Why An Installer

`greetd` reads `/etc/greetd/config.toml`, a root-owned system file. Stow
manages user-home paths and must not link a root system configuration into the
home directory. The canonical config template is tracked here:

```text
installer/noctalia-greeter/config.toml
```

The installer copies that template into `/etc/greetd/config.toml` with the
correct ownership and permissions, then enables `greetd` for future boots.

## Apply

Run from the dotfiles repository:

```bash
sh installer/install-noctalia-greeter.sh
```

The script:

1. Installs `greetd` and `noctalia-greeter` when missing.
2. Installs the tracked configuration template at `/etc/greetd/config.toml`.
3. Pins the graphical greeter to HDMI-A-1 through `/var/lib/noctalia-greeter/greeter.toml`.
4. Adds the GNOME Keyring PAM hooks so the `login` keyring unlocks at login.
5. Disables SDDM.
6. Enables greetd.

## Test

Test the graphical greeter before rebooting:

```bash
sudo systemctl restart greetd
```

Switch to its virtual terminal with `Ctrl+Alt+F1`. Noctalia Greeter should
appear and offer the installed Hyprland session. Log in through the greeter.

## Update

Edit `installer/noctalia-greeter/config.toml`, then rerun the installer. Do
not edit `/etc/greetd/config.toml`, `/var/lib/noctalia-greeter/greeter.toml`,
or `/etc/pam.d/greetd` directly; they are deployed copies.
