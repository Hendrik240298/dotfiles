#!/bin/sh
sudo pacman -S --noconfirm --needed flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
