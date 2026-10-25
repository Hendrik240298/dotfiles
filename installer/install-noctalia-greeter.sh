#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

sudo pacman -S --needed greetd noctalia-greeter
sudo install -Dm644 "$script_dir/noctalia-greeter/config.toml" /etc/greetd/config.toml
sudo install -Dm644 "$script_dir/noctalia-greeter/greeter.toml" /var/lib/noctalia-greeter/greeter.toml
sudo install -Dm644 "$script_dir/noctalia-greeter/pam-greetd" /etc/pam.d/greetd
sudo systemctl disable sddm.service
sudo systemctl enable greetd.service
