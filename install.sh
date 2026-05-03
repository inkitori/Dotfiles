#!/usr/bin/env bash
# Idempotent dotfiles installer. Symlinks each entry in LINKS from
# ~/Dotfiles/<src> to <target>. Existing real files are backed up first.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# Manifest: "<path-inside-Dotfiles>:<absolute-target-path>"
# Add new entries here as you grow the repo.
LINKS=(
  "nvim:$HOME/.config/nvim"
  "ghostty:$HOME/.config/ghostty"
  "zsh/.zshrc:$HOME/.zshrc"
  # examples for future use:
  # "starship/starship.toml:$HOME/.config/starship.toml"
)

link_one() {
  local src="$DOTFILES_DIR/$1"
  local target="$2"

  if [[ ! -e "$src" ]]; then
    echo "skip:   $1 (not present in Dotfiles)"
    return
  fi

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$src" ]]; then
      echo "ok:     $target"
      return
    fi
    echo "relink: $target (was -> $(readlink "$target"))"
    rm "$target"
  elif [[ -e "$target" ]]; then
    local backup="${target}.backup.${TIMESTAMP}"
    echo "backup: $target -> $backup"
    mv "$target" "$backup"
  fi

  ln -s "$src" "$target"
  echo "link:   $target -> $src"
}

for entry in "${LINKS[@]}"; do
  link_one "${entry%%:*}" "${entry#*:}"
done

echo "Done."
