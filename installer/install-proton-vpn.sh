#!/bin/sh

set -eu

sudo pacman -S --noconfirm --needed networkmanager
sudo pacman -S --noconfirm --needed proton-vpn-cli

sudo systemctl stop systemd-networkd.service 2>/dev/null || true
sudo systemctl disable systemd-networkd.service 2>/dev/null || true

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Omarchy uses a passwordless Default_keyring so autologin sessions can use
# libsecret apps without a separate keyring unlock prompt.
KEYRING_DIR="$HOME/.local/share/keyrings"
KEYRING_FILE="$KEYRING_DIR/Default_keyring.keyring"
DEFAULT_KEYRING_FILE="$KEYRING_DIR/default"

mkdir -p "$KEYRING_DIR"

if [ ! -f "$KEYRING_FILE" ]; then
  cat > "$KEYRING_FILE" << EOF
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
EOF
fi

printf '%s\n' 'Default_keyring' > "$DEFAULT_KEYRING_FILE"
chmod 700 "$KEYRING_DIR"
chmod 600 "$KEYRING_FILE"
chmod 644 "$DEFAULT_KEYRING_FILE"

# The Proton VPN CLI expects a user D-Bus session and an unlocked keyring.
# Install this as a login-time user service, not a lingering pre-login service.
sudo systemctl disable --now protonvpn.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/protonvpn.service
sudo systemctl daemon-reload

mkdir -p "$HOME/.config/systemd/user"

cat > "$HOME/.config/systemd/user/protonvpn.service" << 'EOF'
[Unit]
Description=ProtonVPN Auto Connect
Wants=dbus.socket gnome-keyring-daemon.service
After=dbus.socket gnome-keyring-daemon.service

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

sudo loginctl disable-linger "$USER" 2>/dev/null || true

printf '%s\n' "ProtonVPN autostart installed. Run 'systemctl --user start protonvpn.service' to test it now."
