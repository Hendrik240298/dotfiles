#!/bin/bash

# Disable system beep
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf > /dev/null
sudo rmmod pcspkr 2>/dev/null || true

# Disable GNOME audible bell
gsettings set org.gnome.desktop.wm.preferences audible-bell false

# proton vpn cli autostart
mkdir -p ~/.config/autostart
rm -f ~/.config/autostart/proton.vpn.app.gtk.desktop
cat > ~/.config/autostart/proton-vpn-cli.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Proton VPN CLI Autostart
Exec=sh -lc 'sleep 8 && protonvpn connect --country DE'
Terminal=false
X-GNOME-Autostart-enabled=true
EOF
