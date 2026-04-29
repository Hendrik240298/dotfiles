#!/bin/sh

set -eu

disable_unit() {
  sudo systemctl disable --now "$1" 2>/dev/null || true
}

remove_user_unit() {
  systemctl --user disable --now "$1" 2>/dev/null || true
}

# Remove Proton VPN autostart units created by previous setup attempts.
disable_unit protonvpn.service
sudo rm -f /etc/systemd/system/protonvpn.service
sudo systemctl daemon-reload

remove_user_unit protonvpn.timer
remove_user_unit protonvpn.service
rm -f "$HOME/.config/systemd/user/protonvpn.timer" "$HOME/.config/systemd/user/protonvpn.service"
systemctl --user daemon-reload 2>/dev/null || true
sudo loginctl disable-linger "$USER" 2>/dev/null || true

# Restore Omarchy's default network stack: iwd + systemd-networkd + systemd-resolved.
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl enable --now systemd-resolved.service
sudo systemctl enable iwd.service
sudo systemctl enable systemd-networkd.service
sudo systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
sudo systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true

# Stop NetworkManager's stack after the Omarchy services are up.
disable_unit NetworkManager-wait-online.service
disable_unit NetworkManager-dispatcher.service
disable_unit NetworkManager.service
disable_unit wpa_supplicant.service

# Remove packages installed by install-proton-vpn.sh when they are present.
packages=$(pacman -Qq networkmanager proton-vpn-cli 2>/dev/null || true)
if [ -n "$packages" ]; then
  sudo pacman -Rns --noconfirm $packages
fi

# Restart Omarchy services after package removal so they own the interfaces cleanly.
sudo systemctl restart systemd-resolved.service iwd.service systemd-networkd.service

printf '%s\n' "ProtonVPN CLI and NetworkManager removed. Omarchy networking defaults restored."
printf '%s\n' "If Wi-Fi does not reconnect automatically, open Impala and reconnect to your network."
