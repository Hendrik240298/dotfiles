#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
dry_run=false
vault=

usage() {
  printf '%s\n' "Usage: sh $0 [--dry-run] --vault PATH" \
    'Stow the Vim config, theme and local keyboard-adapter files into an existing vault, never HOME.' \
    'Does not download third-party plugins, enable plugins, merge hotkeys or replace conflicting files.'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) dry_run=true; shift ;;
    --vault)
      if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        usage >&2; exit 2
      fi
      vault=$2
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

if [ "$(id -u)" -eq 0 ]; then
  printf '%s\n' 'Run this as your normal user, not with sudo.' >&2
  exit 1
fi
if [ -z "$vault" ] || [ ! -d "$vault" ]; then
  printf '%s\n' 'Specify an existing vault directory with --vault PATH; no vault is guessed or created.' >&2
  exit 1
fi

vault=$(CDPATH= cd -- "$vault" && pwd -P)
home=$(CDPATH= cd -- "$HOME" && pwd -P)
repo=$(CDPATH= cd -- "$repo_root" && pwd -P)
if [ "$vault" = "$home" ] || [ "$vault" = / ] || [ "$vault" = "$repo" ]; then
  printf '%s\n' 'Refusing to use HOME, / or the dotfiles repository as an Obsidian vault.' >&2
  exit 1
fi
command -v stow >/dev/null 2>&1 || {
  printf '%s\n' 'Install stow first.' >&2
  exit 1
}

printf 'Obsidian vault target: %s\n' "$vault"
if ! stow -n -v --no-folding -d "$repo_root" -t "$vault" obsidian; then
  printf '%s\n' 'Vault conflicts: compare and back up existing settings before moving them aside. Do not use --adopt.' >&2
  exit 1
fi
if [ "$dry_run" = true ]; then
  printf '%s\n' 'Dry run only: no vault files changed.'
  exit 0
fi

stow -v --no-folding -d "$repo_root" -t "$vault" obsidian
printf '%s\n' \
  'Obsidian Vim config, theme and local keyboard-adapter files applied. Restart Obsidian.' \
  'Enable Vim mode and Vimrc Support manually. The optional Hendrik Keyboard adapter must also be enabled explicitly.' \
  'Calendar navigation additionally requires Calendar. Native hotkeys remain unchanged; see docs/obsidian/README.md.'
