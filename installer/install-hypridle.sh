#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

sudo pacman -S --needed hypridle hyprlock
stow -R -d "$repo_root" -t "$HOME" hyprland
systemctl --user daemon-reload
systemctl --user enable --now hypridle.service
