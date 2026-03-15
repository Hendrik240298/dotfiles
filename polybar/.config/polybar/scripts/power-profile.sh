#!/usr/bin/env sh

set_profile() {
  current="$1"

  case "$current" in
    power-saver) next="balanced" ;;
    balanced) next="performance" ;;
    performance) next="power-saver" ;;
    *) next="balanced" ;;
  esac

  powerprofilesctl set "$next"
}

if ! command -v powerprofilesctl >/dev/null 2>&1; then
  printf "%%{F#7a83a8}%%{T2}%%{T-} n/a%%{F-}\n"
  exit 0
fi

current="$(powerprofilesctl get 2>/dev/null)"
[ -n "$current" ] || {
  printf "%%{F#7a83a8}%%{T2}%%{T-} n/a%%{F-}\n"
  exit 0
}

if [ "$1" = "next" ]; then
  set_profile "$current"
  exit 0
fi

case "$current" in
  power-saver)
    icon=""
    label="eco"
    color="#9ece6a"
    ;;
  balanced)
    icon=""
    label="bal"
    color="#7aa2f7"
    ;;
  performance)
    icon=""
    label="perf"
    color="#f7768e"
    ;;
  *)
    icon=""
    label="$current"
    color="#c0caf5"
    ;;
esac

printf "%%{F%s}%%{T2}%s%%{T-} %s%%{F-}\n" "$color" "$icon" "$label"
