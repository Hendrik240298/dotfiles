#!/bin/sh

set -eu

sudo pacman -S --noconfirm --needed networkmanager gnome-keyring libsecret proton-vpn-cli

sudo systemctl stop systemd-networkd.service 2>/dev/null || true
sudo systemctl disable systemd-networkd.service 2>/dev/null || true
sudo systemctl disable --now iwd.service 2>/dev/null || true

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Proton VPN stores its login in libsecret. Do not synthesize a keyring file;
# gnome-keyring will create the right one during `protonvpn signin`.
KEYRING_DIR="$HOME/.local/share/keyrings"
DEFAULT_KEYRING_FILE="$KEYRING_DIR/default"

mkdir -p "$KEYRING_DIR"

if [ -f "$KEYRING_DIR/Default.keyring" ]; then
  printf '%s\n' 'Default' > "$DEFAULT_KEYRING_FILE"
  if [ -f "$KEYRING_DIR/Default_keyring.keyring" ]; then
    mv "$KEYRING_DIR/Default_keyring.keyring" "$KEYRING_DIR/Default_keyring.keyring.bak.$(date +%s)"
  fi
fi

chmod 700 "$KEYRING_DIR"
[ ! -f "$KEYRING_DIR/Default.keyring" ] || chmod 600 "$KEYRING_DIR/Default.keyring"
[ ! -f "$DEFAULT_KEYRING_FILE" ] || chmod 644 "$DEFAULT_KEYRING_FILE"

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
TimeoutStartSec=90
ExecStart=/bin/sh -c '/usr/bin/nm-online -q -t 20 || exit 0; account=$(/usr/bin/protonvpn info 2>/dev/null || true); case "$account" in *"Account: '\''None'\''"*) exit 0 ;; esac; /usr/bin/protonvpn connect || exit 0'
Restart=no
EOF

cat > "$HOME/.config/systemd/user/protonvpn.timer" << 'EOF'
[Unit]
Description=Delay ProtonVPN Auto Connect until after login

[Timer]
OnStartupSec=20s
AccuracySec=5s
Unit=protonvpn.service

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user disable --now protonvpn.service 2>/dev/null || true
systemctl --user enable protonvpn.timer

sudo loginctl disable-linger "$USER" 2>/dev/null || true

printf '%s\n' "ProtonVPN autostart installed. Run 'systemctl --user start protonvpn.service' to test it now."
