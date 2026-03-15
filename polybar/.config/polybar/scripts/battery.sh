#!/usr/bin/env sh

battery_dir=""
battery_name=""

format_minutes() {
  minutes="$1"

  if [ -z "$minutes" ] || [ "$minutes" -le 0 ] 2>/dev/null; then
    return 1
  fi

  hours=$((minutes / 60))
  mins=$((minutes % 60))

  if [ "$hours" -gt 0 ]; then
    printf "%sh %sm" "$hours" "$mins"
  else
    printf "%sm" "$mins"
  fi
}

notify_time() {
  [ -n "$battery_name" ] || return 0

  if ! command -v notify-send >/dev/null 2>&1; then
    exit 0
  fi

  if command -v upower >/dev/null 2>&1; then
    info="$(upower -i "/org/freedesktop/UPower/devices/battery_$battery_name" 2>/dev/null)"
    time_value="$(printf "%s\n" "$info" | sed -n 's/^ *time to empty: *//p; s/^ *time to full: *//p' | head -n 1)"

    if [ -n "$time_value" ]; then
      case "$status" in
        Charging)
          notify-send "Battery" "$capacity% - $time_value until full"
          ;;
        Discharging)
          notify-send "Battery" "$capacity% - $time_value remaining"
          ;;
        Full)
          notify-send "Battery" "$capacity% - fully charged"
          ;;
        *)
          notify-send "Battery" "$capacity% - $status"
          ;;
      esac
      exit 0
    fi
  fi

  energy_now="$(cat "$battery_dir/energy_now" 2>/dev/null)"
  power_now="$(cat "$battery_dir/power_now" 2>/dev/null)"
  charge_now="$(cat "$battery_dir/charge_now" 2>/dev/null)"
  current_now="$(cat "$battery_dir/current_now" 2>/dev/null)"
  energy_full="$(cat "$battery_dir/energy_full" 2>/dev/null)"
  charge_full="$(cat "$battery_dir/charge_full" 2>/dev/null)"

  minutes=""

  if [ "$status" = "Discharging" ] && [ -n "$energy_now" ] && [ -n "$power_now" ] && [ "$power_now" -gt 0 ] 2>/dev/null; then
    minutes=$((energy_now * 60 / power_now))
  elif [ "$status" = "Discharging" ] && [ -n "$charge_now" ] && [ -n "$current_now" ] && [ "$current_now" -gt 0 ] 2>/dev/null; then
    minutes=$((charge_now * 60 / current_now))
  elif [ "$status" = "Charging" ] && [ -n "$energy_full" ] && [ -n "$energy_now" ] && [ -n "$power_now" ] && [ "$power_now" -gt 0 ] 2>/dev/null; then
    minutes=$(((energy_full - energy_now) * 60 / power_now))
  elif [ "$status" = "Charging" ] && [ -n "$charge_full" ] && [ -n "$charge_now" ] && [ -n "$current_now" ] && [ "$current_now" -gt 0 ] 2>/dev/null; then
    minutes=$(((charge_full - charge_now) * 60 / current_now))
  fi

  formatted="$(format_minutes "$minutes")"

  if [ -n "$formatted" ]; then
    case "$status" in
      Charging)
        notify-send "Battery" "$capacity% - $formatted until full"
        ;;
      Discharging)
        notify-send "Battery" "$capacity% - $formatted remaining"
        ;;
      Full)
        notify-send "Battery" "$capacity% - fully charged"
        ;;
      *)
        notify-send "Battery" "$capacity% - $status"
        ;;
    esac
  else
    notify-send "Battery" "$capacity% - time estimate unavailable"
  fi

  exit 0
}

for dir in /sys/class/power_supply/BAT*; do
  if [ -d "$dir" ]; then
    battery_dir="$dir"
    battery_name="$(basename "$dir")"
    break
  fi
done

[ -n "$battery_dir" ] || exit 0

capacity="$(cat "$battery_dir/capacity" 2>/dev/null)"
status="$(cat "$battery_dir/status" 2>/dev/null)"

[ -n "$capacity" ] || exit 0

if [ "$1" = "notify" ]; then
  notify_time
fi

icon=""
color=""

if [ "$status" = "Charging" ]; then
  icon=""
  color="#7aa2f7"
elif [ "$capacity" -le 15 ] 2>/dev/null; then
  icon=""
  color="#f7768e"
elif [ "$capacity" -le 35 ] 2>/dev/null; then
  icon=""
  color="#e0af68"
elif [ "$capacity" -le 65 ] 2>/dev/null; then
  icon=""
  color="#c0caf5"
elif [ "$capacity" -le 85 ] 2>/dev/null; then
  icon=""
  color="#9ece6a"
else
  icon=""
  color="#9ece6a"
fi

if [ "$status" = "Full" ]; then
  color="#9ece6a"
fi

printf "%%{F%s}%%{T2}%s%%{T-} %s%%%%{F-}\n" "$color" "$icon" "$capacity"
