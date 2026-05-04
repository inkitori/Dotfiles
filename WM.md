# Window manager stack

Tiling window manager + window borders, driven from this dotfiles repo.
Three tools, one cohesive setup:

| Tool | What it does | Config |
|---|---|---|
| **yabai** | Tiling WM (binary space partitioning). Manages window placement, focus, layout. | `yabai/yabairc` → `~/.config/yabai/` |
| **skhd** | Hotkey daemon. Translates keypresses into yabai commands. | `skhd/skhdrc` → `~/.config/skhd/` |
| **borders** | Paints a colored outline around the focused window so you can find it at a glance. | `borders/bordersrc` → `~/.config/borders/` |

All three share the same palette via `ghostty/colors.sh` → `~/.config/colors.sh`.
The active-window accent is the same pink (`#a85e7a`) as the Ghostty
background, so the focused border and your terminal match.

---

## First-time setup

Assuming `bootstrap.sh` and `install.sh` have already run (so the binaries
are installed and configs are symlinked):

### 1. Grant Accessibility permission

Yabai and skhd both need it. macOS won't let them touch other
windows otherwise.

> **System Settings → Privacy & Security → Accessibility**

Toggle on:
- **yabai**
- **skhd**

If they don't appear in the list, click `+` and add the binaries:
- `/opt/homebrew/bin/yabai`
- `/opt/homebrew/bin/skhd`

After granting, restart the services:
```sh
yabai --restart-service && skhd --restart-service
brew services restart borders
```

Verify they're running (look for numeric PIDs, not `-`):
```sh
launchctl list | grep -E "yabai|skhd|borders"
```

### 2. (Optional but recommended) Scripting addition

Yabai's scripting addition unlocks:
- Smooth window animations
- `mouse_drop_action swap` (drag windows to swap them)
- A few other niceties

It requires **partial SIP disable** — a real security tradeoff. Without it,
yabai works fine; you just lose those features.

#### Step 2a — Partial SIP disable (Recovery Mode, one-time)

1. Reboot. On Apple Silicon: hold the power button until "Loading startup
   options" appears.
2. Click **Options** → Continue → pick your user → enter password.
3. Menu bar: **Utilities → Terminal**.
4. Run:
   ```sh
   csrutil enable --without fs --without debug
   ```
   (This leaves most SIP protections intact; only filesystem + debugging
   restrictions are relaxed — the minimum yabai needs.)
5. Reboot normally.
6. Verify: `csrutil status` should show `System Integrity Protection status:
   unknown.` with both `Filesystem Protections` and `Debugging Restrictions`
   listed as disabled.

#### Step 2b — Sudoers entry for `--load-sa`

So yabai can load its scripting addition at startup without prompting for a
password. The sudoers entry pins the binary by SHA-256 hash, so a tampered
yabai can't abuse it.

```sh
# Compute the hash of the current yabai binary
HASH=$(shasum -a 256 $(which yabai) | awk '{print $1}')

# Stage a sudoers file in /tmp
echo "$USER ALL=(root) NOPASSWD: sha256:$HASH /opt/homebrew/bin/yabai --load-sa" \
  > /tmp/yabai-sudoers-staging

# Validate, then install atomically with the right perms
sudo visudo -c -f /tmp/yabai-sudoers-staging \
  && sudo install -m 0440 -o root -g wheel /tmp/yabai-sudoers-staging /private/etc/sudoers.d/yabai \
  && sudo yabai --load-sa \
  && echo OK
```

> **Re-run this whenever you `brew upgrade yabai`** — the hash in sudoers
> pins to the exact binary, so an upgrade invalidates it. New hash, new
> sudoers entry.

### 3. Reload everything

```sh
alt + ctrl + r       # the configured reload hotkey — restarts yabai + skhd
```

---

## Keybind reference

All keybinds live in `skhd/skhdrc`. The convention:

| Modifier | Used for |
|---|---|
| `alt`             | focus, single-window ops |
| `alt + shift`     | swap windows |
| `alt + ctrl`      | warp (reorder in tree) |
| `alt + cmd`       | resize |
| `ctrl + alt`      | spaces |
| `ctrl + alt + shift` | send window to space + follow |

`cmd` alone is **never** used — it's left for app shortcuts (`cmd-c`,
`cmd-w`, etc.). Plain `ctrl` is left for terminals + readline.

### Window focus & movement

| Keybind | Action |
|---|---|
| `alt + h/j/k/l`            | Focus window west/south/north/east (falls through to display focus at edges) |
| `alt + n` / `alt + p`      | Cycle focus next/previous in stack |
| `alt + shift + h/j/k/l`    | Swap focused window with neighbor |
| `alt + ctrl + h/j/k/l`     | Warp (move and reparent in BSP tree) |

### Resize

| Keybind | Action |
|---|---|
| `alt + cmd + h`     | Shrink left edge by 48px |
| `alt + cmd + l`     | Grow right edge by 48px |
| `alt + cmd + j`     | Grow bottom edge by 48px |
| `alt + cmd + k`     | Shrink top edge by 48px |
| `alt + cmd + 0`     | Balance all windows in space |

### Layout & window state

| Keybind | Action |
|---|---|
| `alt + d`           | Zoom parent (fill the parent split) |
| `alt + f`           | Zoom fullscreen (fill the whole space, yabai-style) |
| `alt + shift + f`   | Native macOS fullscreen |
| `alt + e`           | Toggle window split direction (horizontal ↔ vertical) |
| `alt + t`           | Float and center (8x8 grid, 6x6 centered) |
| `alt + v`           | Set insertion point: south (next window opens below) |
| `alt + z`           | Set insertion point: east (next window opens to the right) |
| `alt + shift + r`   | Rotate space layout 270° |
| `alt + shift + x`   | Mirror space along x-axis |
| `alt + shift + y`   | Mirror space along y-axis |
| `alt + shift + s`   | Toggle BSP ↔ stack layout for current space |

### Spaces (workspaces)

| Keybind | Action |
|---|---|
| `ctrl + alt + 1..0`         | Focus space 1 through 10 |
| `ctrl + alt + shift + 1..0` | Move focused window to space N **and** follow it |
| `ctrl + alt + ←`            | Focus previous space |
| `ctrl + alt + →`            | Focus next space |

### Labeled spaces

Five spaces are labeled and bound to specific apps (see `yabairc`):

| Space | Label     | App     | Focus           | Send window      |
|-------|-----------|---------|-----------------|------------------|
| 1     | `firefox` | Firefox | `ctrl+alt + f`  | `ctrl+alt+shift+f` |
| 2     | `discord` | Discord | `ctrl+alt + d`  | `ctrl+alt+shift+d` |
| 3     | `cmux`    | cmux    | `ctrl+alt + c`  | `ctrl+alt+shift+c` |
| 4     | `spotify` | Spotify | `ctrl+alt + s`  | `ctrl+alt+shift+s` |
| 5     | `code`    | VSCode  | `ctrl+alt + v`  | `ctrl+alt+shift+v` |
| 6     | `slack`   | Slack   | `ctrl+alt + a`  | `ctrl+alt+shift+a` |

Auto-routing of apps to their space requires the **scripting addition**
(step 2 of First-time setup). Without it, the focus binds still work, but
launching an app won't move it to its assigned space — you'll need to
shuffle windows manually.

### Misc

| Keybind | Action |
|---|---|
| `alt + return`      | Open new Ghostty window |
| `alt + ctrl + r`    | Reload yabai + skhd (notification on success) |

### Mouse

`fn` is the modifier — works while it's held:

| Mouse | Action |
|---|---|
| `fn + drag`         | Move floating window |
| `fn + right-drag`   | Resize tiled window |
| `fn + drop on window` | Swap with target window (requires scripting addition) |

---

## Customization

### Colors

All colors come from `ghostty/colors.sh` (symlinked to `~/.config/colors.sh`
and sourced by yabai and borders). Format is `0xAARRGGBB` (alpha-first).

The most likely thing to tweak:

| Variable | Used by | Effect |
|---|---|---|
| `COLOR_ACCENT` | borders (active), yabai (insert feedback) | The "you are here" pink. Change this to re-theme the whole stack. |

After editing, run `alt + ctrl + r` to reload.

### Yabai gaps & padding

In `yabai/yabairc`:
```sh
top_padding    12
bottom_padding 12
left_padding   12
right_padding  12
window_gap     10
```

Smaller values = tighter packing.

### Float-by-default apps

Add to the `yabai -m rule --add app="..."` regex in `yabairc`. Apps matched
here open as floating windows (System Settings, Calculator, Raycast, etc.).
The pattern is anchored — exact match needed.

---

## Troubleshooting

### Yabai isn't tiling new windows

1. Check the service is up: `launchctl list | grep yabai` — needs a numeric PID.
2. Check Accessibility permission is granted (System Settings → Privacy).
3. Check the err log: `tail -50 /tmp/yabai_$USER.err.log`.
4. Reload: `yabai --restart-service`.

### Skhd hotkeys don't fire

1. `launchctl list | grep skhd` — numeric PID?
2. Accessibility granted?
3. Test syntax: `skhd -V` (validate config). Stops on first error with line number.
4. Conflict with another app's hotkey? macOS gives priority to system + frontmost-app shortcuts. Try a different modifier combo.
5. Err log: `tail -50 /tmp/skhd_$USER.err.log`.

### "could not access accessibility features"

Same fix as above: System Settings → Privacy & Security → Accessibility →
toggle the binary on. Sometimes the toggle needs to be *flipped off then
on again* after a yabai/skhd upgrade — macOS invalidates the entry when
the binary changes.

### "System Integrity Protection: Filesystem Protections and Debugging Restrictions must be disabled"

You ran `sudo yabai --load-sa` without partial SIP disable. Either:
- Do step 2a above (Recovery Mode → `csrutil enable --without fs --without debug`), or
- Skip the scripting addition (yabai still works without it; you just lose animations + drag-to-swap).

### Service started but immediately stopped (`launchctl list` shows PID `-`)

The launch agent loaded but the binary crashed. Always check the err log:
```sh
tail -50 /tmp/yabai_$USER.err.log
tail -50 /tmp/skhd_$USER.err.log
```

### After `brew upgrade`, scripting addition stops working

The hash in `/private/etc/sudoers.d/yabai` no longer matches the binary.
Re-run the sudoers chain in step 2b with the new hash.

---

## Useful commands

```sh
# query yabai state
yabai -m query --windows                  # all windows
yabai -m query --windows --window         # focused window
yabai -m query --spaces                   # all spaces
yabai -m query --spaces --space           # current space (incl. layout type)
yabai -m query --displays                 # all displays

# move/manage from the CLI
yabai -m space --create                   # add a new space
yabai -m space --destroy                  # remove current space
yabai -m window --close                   # close focused window
yabai -m window --minimize                # minimize focused window

# service control
yabai --restart-service                   # also: --start-service / --stop-service
skhd --restart-service
brew services restart borders

# logs
tail -f /tmp/yabai_$USER.{out,err}.log
tail -f /tmp/skhd_$USER.{out,err}.log
```

---

## Uninstall

```sh
# stop services
yabai --stop-service
skhd --stop-service
brew services stop borders

# remove launch agent plists
rm -f ~/Library/LaunchAgents/{com.asmvik.yabai,com.koekeishiya.skhd,homebrew.mxcl.borders}.plist

# remove sudoers entry (if you set one up)
sudo rm -f /private/etc/sudoers.d/yabai

# remove config symlinks (real configs stay in ~/dotfiles/ — re-installable)
rm -f ~/.config/{yabai,skhd,borders} ~/.config/colors.sh

# uninstall the binaries (optional — they take ~minimal disk)
brew uninstall yabai skhd borders

# (optional) re-enable full SIP — Recovery Mode, Terminal:
#   csrutil enable
```
