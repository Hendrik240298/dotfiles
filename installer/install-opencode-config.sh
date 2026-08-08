#!/bin/sh

set -eu

script_dir=$(dirname "$0")
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
source_file="$repo_root/opencode/.config/opencode/opencode.json"
target_file="$HOME/.config/opencode/opencode.json"

mkdir -p "$HOME/.config/opencode"

if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
  if ! cmp -s "$source_file" "$target_file"; then
    diff -u "$target_file" "$source_file" || true
    printf '%s\n' "Refusing to replace a divergent OpenCode configuration." >&2
    exit 1
  fi
  rm "$target_file"
fi

stow -R -d "$repo_root" -t "$HOME" opencode
cmp -s "$source_file" "$target_file"
