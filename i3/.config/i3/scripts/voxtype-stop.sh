#!/usr/bin/env sh

state_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/voxtype/state"
runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/voxtype"
clipboard_before="$runtime_dir/clipboard-before"
clipboard_after="$runtime_dir/clipboard-after"
seen_transcribing=0

voxtype record stop >/dev/null 2>&1 || exit 1

for _ in $(seq 1 600); do
  if [ -f "$state_file" ]; then
    state=$(tr -d '\n' < "$state_file")
    if [ "$state" = "transcribing" ]; then
      seen_transcribing=1
    fi
    if [ "$seen_transcribing" -eq 1 ] && { [ "$state" = "idle" ] || [ "$state" = "stopped" ]; }; then
      for _clipboard_wait in $(seq 1 20); do
        xclip -selection clipboard -o > "$clipboard_after" 2>/dev/null || : > "$clipboard_after"
        if [ ! -f "$clipboard_before" ] || ! cmp -s "$clipboard_before" "$clipboard_after"; then
          break
        fi
        sleep 0.1
      done
      if [ -f "$clipboard_before" ] && cmp -s "$clipboard_before" "$clipboard_after"; then
        exit 1
      fi
      xclip -selection clipboard < "$clipboard_after"
      xclip -selection primary < "$clipboard_after"
      copyq copy - < "$clipboard_after"
      copyq paste >/dev/null 2>&1 &
      exit 0
    fi
  fi
  sleep 0.1
done

exit 1
