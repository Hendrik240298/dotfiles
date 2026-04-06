#!/usr/bin/env sh

runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/voxtype"
clipboard_before="$runtime_dir/clipboard-before"

mkdir -p "$runtime_dir"
xclip -selection clipboard -o > "$clipboard_before" 2>/dev/null || : > "$clipboard_before"

systemctl --user start voxtype.service >/dev/null 2>&1 || true

for _ in 1 2 3 4 5 6 7 8 9 10; do
  if voxtype record start >/dev/null 2>&1; then
    exit 0
  fi
  sleep 0.1
done

exit 1
