#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

paru -S --needed voxtype-bin wl-clipboard stow

# Check for existing files before Stow touches the live configuration.
stow -n -d "$repo_root" -t "$HOME" voxtype hyprland
stow -d "$repo_root" -t "$HOME" voxtype hyprland

# Download the model selected by the Stow-managed config.
voxtype setup --download
sudo voxtype setup gpu --enable
systemctl --user daemon-reload
systemctl --user enable voxtype.service
systemctl --user restart voxtype.service

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hyprctl reload
  hyprctl configerrors
  noctalia msg config-reload
fi

printf '%s\n' 'Voxtype is ready: Super+Shift+R toggles recording; paste the transcript from the clipboard.'
printf '%s\n' 'Noctalia mic: left-click toggles the daemon; right-click toggles recording.'
