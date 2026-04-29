#!/bin/sh

set -eu

sudo pacman -S --noconfirm --needed networkmanager proton-vpn-cli

sudo systemctl stop systemd-networkd.service 2>/dev/null || true
sudo systemctl disable systemd-networkd.service 2>/dev/null || true
sudo systemctl disable --now iwd.service 2>/dev/null || true

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

sudo systemctl disable --now protonvpn.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/protonvpn.service
sudo systemctl daemon-reload

systemctl --user disable --now protonvpn.timer 2>/dev/null || true
systemctl --user disable --now protonvpn.service 2>/dev/null || true
rm -f "$HOME/.config/systemd/user/protonvpn.timer" "$HOME/.config/systemd/user/protonvpn.service"
systemctl --user daemon-reload 2>/dev/null || true

sudo loginctl disable-linger "$USER" 2>/dev/null || true

printf '%s\n' "ProtonVPN CLI installed without autostart. NetworkManager is enabled."
