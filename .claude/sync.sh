#!/usr/bin/env bash
# Refresh ~/dotfiles/.claude/{memory,transcripts}/ from a Claude project dir.
# Usage: ./sync.sh [SOURCE_PROJECT_DIR]
#   default SOURCE: ~/.claude/projects/-Users-enyouki--config-nvim

set -euo pipefail

SRC="${1:-$HOME/.claude/projects/-Users-enyouki--config-nvim}"
DEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "$SRC" ]]; then
  echo "Source dir not found: $SRC" >&2
  exit 1
fi

echo "Source: $SRC"
echo "Dest:   $DEST"
echo

if [[ -d "$SRC/memory" ]]; then
  rm -rf "$DEST/memory"
  cp -R "$SRC/memory" "$DEST/memory"
  echo "Updated memory/"
fi

mkdir -p "$DEST/transcripts"
shopt -s nullglob
for f in "$SRC"/*.jsonl; do
  cp "$f" "$DEST/transcripts/"
done
for d in "$SRC"/*/; do
  [[ "$(basename "$d")" == "memory" ]] && continue
  rm -rf "$DEST/transcripts/$(basename "$d")"
  cp -R "$d" "$DEST/transcripts/"
done
echo "Updated transcripts/"

echo
echo "Done."
