#!/bin/sh
set -eu

sudo pacman -S --noconfirm --needed calibre

mkdir -p "$HOME/.local/bin"

for name in \
  calibre \
  calibre-complete \
  calibre-customize \
  calibre-debug \
  calibre-parallel \
  calibre-server \
  calibre-smtp \
  calibredb \
  ebook-convert \
  ebook-device \
  ebook-edit \
  ebook-meta \
  ebook-polish \
  ebook-viewer \
  fetch-ebook-metadata \
  lrf2lrs \
  lrfviewer \
  lrs2lrf \
  markdown-calibre \
  web2disk
do
  cat >"$HOME/.local/bin/$name" <<EOF
#!/bin/sh
export PATH="/usr/bin:\$PATH"
exec /usr/bin/python "/usr/bin/$name" "\$@"
EOF
  chmod +x "$HOME/.local/bin/$name"
done

"$HOME/.local/bin/calibre" --version >/dev/null
"$HOME/.local/bin/calibre-debug" -c 'from calibre.ptempfile import PersistentTemporaryDirectory; PersistentTemporaryDirectory("_installer_test")' >/dev/null
