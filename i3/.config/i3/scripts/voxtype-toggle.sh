#!/usr/bin/env sh

state_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/voxtype/state"
script_dir=$(dirname "$0")
state=

if [ -f "$state_file" ]; then
  state=$(tr -d '\n' < "$state_file")
fi

case "$state" in
  recording)
    exec "$script_dir/voxtype-stop.sh"
    ;;
  transcribing)
    exit 0
    ;;
  *)
    exec "$script_dir/voxtype-start.sh"
    ;;
esac
