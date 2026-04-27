#!/bin/sh

set -eu

sudo pacman -S --noconfirm --needed networkmanager
sudo pacman -S --noconfirm --needed proton-vpn-cli

sudo systemctl stop systemd-networkd.service 2>/dev/null || true
sudo systemctl disable systemd-networkd.service 2>/dev/null || true

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# The Proton VPN CLI expects a user D-Bus session. A system service running as
# root fails at boot, so install this as a user service and enable lingering.
sudo systemctl disable --now protonvpn.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/protonvpn.service
sudo systemctl daemon-reload

mkdir -p "$HOME/.config/systemd/user"

cat > "$HOME/.config/systemd/user/protonvpn.service" << 'EOF'
[Unit]
Description=ProtonVPN Auto Connect
Wants=dbus.socket
After=dbus.socket

[Service]
Type=oneshot
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus
ExecStartPre=/usr/bin/nm-online -q -t 120
ExecStart=/usr/bin/protonvpn connect
RemainAfterExit=yes
Restart=on-failure
RestartSec=30

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable protonvpn.service

sudo loginctl enable-linger "$USER"

printf '%s\n' "ProtonVPN autostart installed. Run 'systemctl --user start protonvpn.service' to test it now."
