#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
dry_run=false
configs_only=false
replace_configs=false

for arg do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --configs-only) configs_only=true ;;
    --replace-configs) replace_configs=true ;;
    -h|--help)
      printf '%s\n' "Usage: sh $0 [--dry-run] [--configs-only] [--replace-configs]" \
        'Install the personal app bundle recorded from the laptop in November 2026.' \
        'Stows vscode and flatpak settings; --configs-only skips package installation.' \
        '--replace-configs backs up conflicting setting files before applying dotfiles.' \
        'Obsidian vault settings: use install-obsidian-config.sh with an explicit vault.' \
        'Does not install all scripts, change monitor settings or download AI models.'
      exit 0
      ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

if [ "$(id -u)" -eq 0 ]; then
  printf '%s\n' 'Run this as your normal user, not with sudo.' >&2
  exit 1
fi

printf '%s\n' \
  'Personal apps: Brave, Code OSS, Obsidian, Super Productivity, Synology Drive' \
  'Supporting tools: HyprMon, Flatpak (with Flathub), Python' \
  'Saved home-directory configs: vscode (VS Code + Code OSS) and flatpak (global overrides)'

set -- vscode flatpak
if command -v stow >/dev/null 2>&1; then
  if [ "$replace_configs" = true ]; then
    perl "$script_dir/prepare-configs.pl" --repo "$repo_root" --target "$HOME" "$@"
  elif ! stow -n -v --no-folding -d "$repo_root" -t "$HOME" "$@"; then
    printf '%s\n' 'Stow conflicts: compare and back up the listed live files before moving them aside. Do not use --adopt.' >&2
    exit 1
  fi
elif [ "$configs_only" = true ]; then
  printf '%s\n' 'Install stow first to use --configs-only.' >&2
  exit 1
else
  printf '%s\n' 'Stow is not installed yet; conflict checking will run after installing it.'
fi

if [ "$configs_only" = false ]; then
  printf '%s\n' 'Brave will be set as the default browser; app sign-ins remain manual.'
fi

if [ "$dry_run" = true ]; then
  printf '%s\n' 'Dry run only: no installation or settings changes.'
  exit 0
fi

if [ "$configs_only" = false ]; then
  command -v pacman >/dev/null 2>&1 || {
    printf '%s\n' 'This installer requires Arch Linux or CachyOS.' >&2
    exit 1
  }
  command -v paru >/dev/null 2>&1 || {
    printf '%s\n' 'Install paru first for Brave, Synology Drive and HyprMon.' >&2
    exit 1
  }

  sudo pacman -S --needed stow diffutils code obsidian super-productivity
fi

# Link individual files before apps start writing cache/state into their config
# directories. Never fold whole app directories into the source repository.
if [ "$replace_configs" = true ]; then
  perl "$script_dir/prepare-configs.pl" --apply --repo "$repo_root" --target "$HOME" "$@"
fi
stow -n -v --no-folding -d "$repo_root" -t "$HOME" "$@"
stow -v --no-folding -d "$repo_root" -t "$HOME" "$@"

if [ "$configs_only" = true ]; then
  printf '%s\n' 'Saved app configs applied. Restart VS Code/Code OSS to load them.'
  exit 0
fi

# Keep app-specific setup in the existing focused installers. Do not run every
# install-*.sh: several change networking/login managers or download big models.
for app in brave hyprmon synology flatpak python; do
  sh "$script_dir/install-$app.sh"
done

printf '%s\n' \
  'Personal apps and saved home-directory configs installed. Restart running apps.' \
  'Accounts/sync jobs remain manual. For Obsidian vault settings, use install-obsidian-config.sh.'
