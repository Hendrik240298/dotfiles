#!/usr/bin/env sh

set -eu

xdg-mime default org.gnome.Evince.desktop application/pdf && for t in image/avif image/bmp image/gif image/heic image/jpeg image/jpg image/png image/svg+xml image/tiff image/webp; do xdg-mime default org.gnome.eog.desktop "$t"; done && for t in text/html x-scheme-handler/about x-scheme-handler/http x-scheme-handler/https x-scheme-handler/unknown; do xdg-mime default brave-browser.desktop "$t"; done
