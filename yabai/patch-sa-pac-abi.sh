#!/usr/bin/env bash
# Patch the yabai scripting-addition loader's PAC ABI from v1 (0x81) to v0 (0x80)
# so it can inject into Sequoia's Dock.app. Re-run after every `brew upgrade yabai`.
# Source: https://github.com/asmvik/yabai/issues/2686
#
# Usage:
#   sudo yabai --load-sa     # may fail with "protection failure" — run anyway to install loader
#   sudo ~/dotfiles/yabai/patch-sa-pac-abi.sh
#   sudo yabai --load-sa     # should succeed silently this time
set -euo pipefail

patch_caps() {
    [ ! -f "$1" ] && echo "Error: '$1' not found" && return 1

    read I O <<< $(otool -f "$1" | awk '/architecture/{i=$2} /capabilities 0x81/{f=1} f&&/offset/{print i, $2; exit}')

    if [ -n "${O:-}" ]; then
        printf '\x80' | dd of="$1" bs=1 seek=$((8 + I*20 + 4)) count=1 conv=notrunc 2>/dev/null
        printf '\x80' | dd of="$1" bs=1 seek=$((O + 11)) count=1 conv=notrunc 2>/dev/null

        echo "Patched $1 (arch $I). Resigning…"
        codesign -f -s - "$1" &>/dev/null
        echo "Done."
    else
        echo "No 0x81 capability found in '$1' — already patched or not affected."
    fi
}

patch_caps "/Library/ScriptingAdditions/yabai.osax/Contents/MacOS/loader"
