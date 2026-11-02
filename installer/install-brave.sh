#!/bin/sh
set -eu

paru -S --noconfirm --needed brave-bin
xdg-settings set default-web-browser brave-browser.desktop
