#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
dry_run=false
with_apps=false
with_voxtype=false
replace_configs=false
guided=false
if [ "$#" -eq 0 ]; then
  guided=true
fi

usage() {
  printf '%s\n' \
    "Usage: sh $0 [--minimal] [--dry-run] [--with-apps] [--with-voxtype] [--replace-configs]" \
    'No flags: guided yes/no questions, with short explanations and a final confirmation.' \
    'New-system recommendations: apps YES, replace configs YES, Voxtype NO, dry-run NO.' \
    'With explicit flags: no setup questions; omitted options stay off.' \
    '--minimal: install only the base desktop without setup questions.' \
    '--with-apps: also install the personal app bundle and its saved home-directory configs.' \
    '--with-voxtype: opt in to dictation, GPU setup and the large-v3 model (~3 GB).' \
    '--without-voxtype: accepted for compatibility; Voxtype is already off by default.' \
    '--replace-configs: back up conflicting setting files, then prefer the saved dotfiles.' \
    'Laptop/PC display profiles are detected automatically; ~/.config/hypr/machine optionally selects a local profile.' \
    'Guide: docs/hyprland/INSTALL.md' \
    'Never uses --adopt or changes the login manager; conflicts stop unless replacement is requested.'
}

for arg do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --with-apps) with_apps=true ;;
    --with-voxtype) with_voxtype=true ;;
    --without-voxtype) with_voxtype=false ;;
    --replace-configs) replace_configs=true ;;
    --minimal) : ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

if [ "$(id -u)" -eq 0 ]; then
  printf '%s\n' 'Run this as your normal user, not with sudo; individual package steps request sudo.' >&2
  exit 1
fi

command -v pacman >/dev/null 2>&1 || {
  printf '%s\n' 'This installer requires Arch Linux or CachyOS.' >&2
  exit 1
}

ask_yes_no() {
  if [ "$2" = yes ]; then
    prompt_default='[Y/n]'
  else
    prompt_default='[y/N]'
  fi
  while :; do
    printf '%s %s ' "$1" "$prompt_default"
    if ! IFS= read -r answer; then
      printf '\n%s\n' 'Input ended; cancelled without making changes.' >&2
      exit 1
    fi
    case "$answer" in
      '') [ "$2" = yes ]; return ;;
      y|Y|yes|Yes|YES) return 0 ;;
      n|N|no|No|NO) return 1 ;;
      *) printf '%s\n' 'Please answer y or n (or press Enter for the shown default).' ;;
    esac
  done
}

if [ "$guided" = true ]; then
  if [ ! -t 0 ]; then
    printf '%s\n' \
      'No flags starts the guided installer; run it in a terminal.' \
      'For scripting, use explicit flags (or --minimal for the base only).' >&2
    exit 1
  fi
  printf '%s\n' \
    'Hyprland / Noctalia guided setup' \
    'Press Enter for the capitalized default. No changes until you confirm.' \
    'Recommended on a NEW system: apps YES, replace configs YES, Voxtype NO, preview-only NO.' \
    '' \
    'Personal apps + saved configs: Brave, Code OSS, Obsidian, Super Productivity, Synology Drive and supporting tools.'
  if ask_yes_no 'Enable --with-apps? (Recommended for a new system)' yes; then
    with_apps=true
  fi
  printf '\n%s\n' 'Use your dotfiles instead of stock defaults. Conflicting setting files are backed up; unrelated data stays untouched.'
  if ask_yes_no 'Enable --replace-configs? (Recommended for a new system)' yes; then
    replace_configs=true
  fi
  printf '\n%s\n' 'Voxtype dictation: GPU setup and a ~3 GB model download. Leave off on this laptop.'
  if ask_yes_no 'Enable --with-voxtype?' no; then
    with_voxtype=true
  fi
  printf '\n%s\n' 'Preview only: show the plan without installing, backing up, linking files or enabling services.'
  if ask_yes_no 'Enable --dry-run?' no; then
    dry_run=true
  fi
  printf '\nSelected: apps=%s, replace-configs=%s, voxtype=%s, dry-run=%s\n' \
    "$with_apps" "$replace_configs" "$with_voxtype" "$dry_run"
  if [ "$dry_run" = false ]; then
    if ! ask_yes_no 'Install with these choices?' no; then
      printf '%s\n' 'Cancelled; no changes made.'
      exit 0
    fi
  fi
fi

if [ "$dry_run" = false ] && { [ "$with_apps" = true ] || [ "$with_voxtype" = true ]; }; then
  command -v paru >/dev/null 2>&1 || {
    printf '%s\n' 'Install paru first for the optional AUR apps/Voxtype. The base desktop does not need it.' >&2
    exit 1
  }
fi

# Check before installing anything. Never use --adopt here: it replaces the
# saved dotfiles with the machine's existing configuration, not vice versa.
set -- hyprland ghostty
if [ "$with_apps" = true ]; then
  set -- "$@" vscode flatpak
fi
if [ "$with_voxtype" = true ]; then
  set -- "$@" voxtype
fi
if command -v stow >/dev/null 2>&1; then
  if [ "$replace_configs" = true ]; then
    perl "$script_dir/prepare-configs.pl" --repo "$repo_root" --target "$HOME" "$@"
  elif ! stow -n -v --no-folding -d "$repo_root" -t "$HOME" "$@"; then
    printf '%s\n' 'Stow conflicts: compare and back up the listed live files before moving them aside. Do not use --adopt.' >&2
    exit 1
  fi
else
  printf '%s\n' 'Stow is not installed yet; conflict checking will run after installing it.'
fi

printf '%s\n' \
  'Base desktop: Hyprland, Noctalia, UWSM, Hypridle/Hyprlock, Hyprpicker' \
  'Base tools: Ghostty, Nautilus, Neovim, Satty, calculator, btop, clipboard, fonts and launch helpers' \
  "Stow packages: $*" \
  "Personal app bundle: $with_apps" \
  "Voxtype model/service setup: $with_voxtype" \
  "Back up and replace conflicting settings: $replace_configs" \
  'Display detection at login/reload: eDP-1 -> laptop; otherwise HDMI-A-1 + DP-1 -> PC; anything else -> fallback.' \
  'Laptop default: 1920x1080 at 60.03 Hz, scale 1.00; PC retains its saved dual-monitor layout.' \
  'Display profiles: ~/.config/hypr/config/monitor_profiles.lua; local HyprMon override loads last on the laptop only.' \
  'Keyboard: plain US globally for firmware Q11; software Colemak only on the ThinkPad built-in keyboard.' \
  'Keyboard device names must be verified on the laptop. Guide: docs/hyprland/INSTALL.md'

if [ "$dry_run" = true ] && [ "$with_apps" = true ]; then
  if [ "$replace_configs" = true ]; then
    sh "$script_dir/install-apps.sh" --dry-run --replace-configs
  else
    sh "$script_dir/install-apps.sh" --dry-run
  fi
fi

if [ "$dry_run" = true ]; then
  printf '%s\n' 'Dry run only: no packages, files, services or settings changed.'
  exit 0
fi

sudo pacman -S --needed \
  stow diffutils hyprland noctalia uwsm \
  ghostty nautilus neovim satty \
  gnome-calculator btop jq wl-clipboard xorg-xhost hyprpicker \
  hypridle hyprlock ttf-jetbrains-mono-nerd

# Recheck after installation, including when Stow was initially missing.
if [ "$replace_configs" = true ]; then
  perl "$script_dir/prepare-configs.pl" --apply --repo "$repo_root" --target "$HOME" "$@"
fi
stow -n -v --no-folding -d "$repo_root" -t "$HOME" "$@"
stow -v --no-folding -d "$repo_root" -t "$HOME" "$@"

# Finish the base before optional AUR installations, so an app failure does not
# leave idle locking disabled. No sudo is needed for these user services.
systemctl --user daemon-reload
systemctl --user enable --now hypridle.service

noctalia config validate "$HOME/.config/noctalia/config.toml"

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hyprctl reload
  errors=$(hyprctl configerrors)
  if [ -n "$errors" ]; then
    printf '%s\n' "$errors" >&2
    exit 1
  fi
  noctalia msg config-reload
  # The saved Ghostty config selects the generated "noctalia" theme.
  noctalia msg templates-apply
fi

if [ "$with_apps" = true ]; then
  if [ "$replace_configs" = true ]; then
    sh "$script_dir/install-apps.sh" --replace-configs
  else
    sh "$script_dir/install-apps.sh"
  fi
fi
if [ "$with_voxtype" = true ]; then
  sh "$script_dir/install-voxtype.sh"
  if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    noctalia msg plugins enable gabedunn/voxtype
    noctalia msg config-reload
  fi
fi

printf '%s\n' \
  'Desktop installation complete. Log into a Hyprland (UWSM) session.' \
  'Q11 uses its firmware Colemak; only the built-in ThinkPad keyboard receives software Colemak.' \
  'Verify its device name in hyprctl devices. Caps Lock is Compose; Alt+AltGr switches to US international.' \
  'Personal app shortcuts require --with-apps; Voxtype requires --with-voxtype.' \
  'Login manager unchanged. Optional Noctalia greeter: sh installer/install-noctalia-greeter.sh'
