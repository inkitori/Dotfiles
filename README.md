# dotfiles

Personal configuration files, version-controlled and symlinked into place.
Real files live here under `~/dotfiles/<app>/`. Running `./install.sh` symlinks
each app's directory into the right spot under `$HOME`.

## What's here

- **[`nvim/`](nvim/README.md)** → `~/.config/nvim` — Neovim IDE config (lazy.nvim,
  LSP, completion, treesitter, telescope, neo-tree, etc.). See
  [`nvim/README.md`](nvim/README.md) for keymaps, daily workflow, and how to
  add/configure plugins.
- **Window manager stack** — `yabai/`, `skhd/`, `borders/`.
  Tiling WM + hotkeys + window-border highlighter, all sharing
  one rose-pine + pink palette via `colors.sh`. See [`WM.md`](WM.md) for
  setup (incl. the SIP / scripting-addition decision), keybind reference,
  customization, and troubleshooting.
- `ghostty/` → `~/.config/ghostty` — Ghostty terminal (Rose Pine + custom pink,
  0.70 opacity, macOS glass blur).
- `ghostty/colors.sh` → `~/.config/colors.sh` — shared palette sourced by
  yabai and borders. Edit once, the whole stack re-themes.
- `zsh/.zshrc` → `~/.zshrc` — minimal zsh setup: aliases, PATH, modern CLI tool
  initializers (starship, zoxide, fzf, direnv, eza, bat).
- `.claude/` — local-only Claude Code context (memory + transcripts).
  **Gitignored**; not pushed.
- `bootstrap.sh` — installs the CLI toolchain via Homebrew on a fresh machine.
- `install.sh` — symlinks configs into place.

## First-time setup on a fresh machine

```sh
git clone <your-remote> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh   # installs Homebrew + CLI tools (nvim, ghostty, fzf, etc.)
./install.sh     # symlinks configs into ~/.config/* and ~/.zshrc
```

Then:

1. Open Ghostty (the new shell will pick up your `.zshrc`).
2. Run `nvim` once and wait for lazy.nvim to install plugins. Quit and relaunch.
3. Inside nvim: `:MasonToolsInstall` — installs LSP servers, formatters, and
   linters. Wait for the bottom-of-screen progress to settle.

You're done with the editor side. For the **window manager** (yabai + skhd
+ borders), there's one more round of setup that can't be
scripted (Accessibility grants in System Settings, and an optional partial
SIP disable in Recovery Mode for animations) — see [`WM.md`](WM.md).

See [`nvim/README.md`](nvim/README.md) for editor usage and
[`WM.md`](WM.md) for the WM keybind reference.

## install.sh — how it works

The installer is **idempotent** — running it twice is safe. For each managed
path:

- if it's already the correct symlink → skip silently
- if it's a different symlink → relink
- if it's a real file/dir → back it up to `<path>.backup.<timestamp>`, then
  symlink
- if nothing exists there → just symlink

The full mapping is the `LINKS` array near the top of `install.sh`.

## Adding a new app

1. Move (or copy) the app's config into `~/dotfiles/<app>/`.
2. Add one line to the `LINKS` array in `install.sh`:
   ```bash
   "<app>:$HOME/.config/<app>"
   ```
   For dotfiles in `$HOME` directly, point at the file:
   ```bash
   "starship/starship.toml:$HOME/.config/starship.toml"
   ```
3. Run `./install.sh`.
4. Commit.

## Uninstall

Remove the symlink (`rm ~/.config/<app>` or `rm ~/.zshrc`). If you want the
previous content back, the installer left a `<path>.backup.<timestamp>` next
to it.

## Per-app notes

### Neovim

See [`nvim/README.md`](nvim/README.md) for the full reference. TL;DR:

- First launch: lazy.nvim self-installs and pulls every plugin. Wait, quit,
  relaunch.
- `:Mason` to confirm LSP servers and formatters installed.
- Requires a Nerd Font (JetBrainsMono Nerd Font is installed by `bootstrap.sh`).
- For C/C++ projects, generate `compile_commands.json` so `clangd` understands
  your build (CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`).

### Ghostty

The pink (`#a85e7a`) background, `0.70` opacity, and macOS glass blur are
deliberate — Neovim is configured with a transparent background to show this
through.

### Window manager

See [`WM.md`](WM.md) for the full reference. TL;DR keybinds:

- `alt + h/j/k/l` — focus window in direction
- `alt + shift + h/j/k/l` — swap focused window with neighbor
- `alt + ctrl + h/j/k/l` — warp (reparent in tree)
- `alt + cmd + h/j/k/l` — resize edges
- `ctrl + alt + 1..0` — focus space N
- `ctrl + alt + shift + 1..0` — send window to space N + follow
- `alt + return` — new Ghostty window
- `alt + ctrl + r` — reload yabai + skhd

`cmd` alone is reserved for app shortcuts. See `WM.md` for the full table
and the design rationale.

### Claude context

`.claude/` holds the memory + transcripts that this dotfiles work was built
through. It's **gitignored** (so private chat content never gets pushed).
Layout:

```
.claude/
├── memory/          -- structured notes Claude wrote about you, the project,
│                       and your preferences. Loaded by future Claude sessions.
└── transcripts/     -- raw .jsonl conversation logs (large, mostly for your
                        own reference).
```

To **continue a Claude session in this directory**:
- `cd ~/dotfiles && claude --continue` — resumes the most recent session for
  this project dir. Claude looks up sessions by current working directory, so
  starting from `~/dotfiles` keeps the context here together over time.

The `~/.claude/projects/-Users-enyouki-dotfiles/` directory is the Claude side
of this — it's set up to point at `~/dotfiles/.claude/` so memory stays in
sync.

## Tools installed by bootstrap.sh

**Brew formulas:** `neovim`, `ripgrep`, `fd`, `fzf`, `zoxide`, `eza`, `bat`,
`starship`, `direnv`, `fastfetch`, `yt-dlp`, `jq`, `git`, `llvm`, `node`,
`tree-sitter`, `tree-sitter-cli`, `imagemagick`, `gh`.

**WM stack** (from `koekeishiya/formulae` and `FelixKratz/formulae` taps):
`yabai`, `skhd`, `borders`.

**Brew casks:** `ghostty`, `font-jetbrains-mono-nerd-font`.

**Other:** `uv` (Python package & version manager) via `astral.sh/uv/install.sh`.

To add a new tool: append to the `BREW_FORMULAS` or `BREW_CASKS` array in
`bootstrap.sh`. To remove one, delete the line — the script doesn't uninstall
existing things.
