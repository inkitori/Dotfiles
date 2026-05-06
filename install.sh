#!/usr/bin/env bash
# Idempotent dotfiles installer. Symlinks each entry in LINKS from
# ~/dotfiles/<src> to <target>. Existing real files are backed up first.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# Manifest: "<path-inside-dotfiles>:<absolute-target-path>"
# Add new entries here as you grow the repo.
LINKS=(
  "nvim:$HOME/.config/nvim"
  "ghostty:$HOME/.config/ghostty"
  "ghostty/colors.sh:$HOME/.config/colors.sh"   # shared palette (yabai + borders source it)
  "zsh/.zshrc:$HOME/.zshrc"
  "yabai:$HOME/.config/yabai"
  "skhd:$HOME/.config/skhd"
  "borders:$HOME/.config/borders"
  # cmux reads a ghostty-format config from its app-support dir, not ~/.config/ghostty
  "cmux/config:$HOME/Library/Application Support/com.cmuxterm.app/config"
  "starship/starship.toml:$HOME/.config/starship.toml"
)

link_one() {
  local src="$DOTFILES_DIR/$1"
  local target="$2"

  if [[ ! -e "$src" ]]; then
    echo "skip:   $1 (not present in dotfiles)"
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
