#!/usr/bin/env sh

state_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/voxtype/state"

if [ ! -f "$state_file" ]; then
  exit 0
fi

state=$(tr -d '\n' < "$state_file")

case "$state" in
  recording)
    printf 'DICTATE'
    ;;
  transcribing)
    printf 'TRANSCRIBE'
    ;;
  *)
    exit 0
    ;;
esac
