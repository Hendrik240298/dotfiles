#!/bin/sh

set -eu

script_dir=$(dirname "$0")
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

stow -R -d "$repo_root" -t "$HOME" ollama
systemctl --user daemon-reload
systemctl --user enable --now ollama.service
sudo loginctl enable-linger "$USER"
