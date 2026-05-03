# Dotfiles

Personal configuration files, version-controlled and symlinked into place.

Real files live here under `~/Dotfiles/<app>/`. Running `./install.sh` symlinks
each app's directory into the right spot under `$HOME` (typically `~/.config/<app>`).

## What's here

- `nvim/` → `~/.config/nvim` — Neovim IDE config (lazy.nvim, LSP, completion, treesitter, telescope, neo-tree, etc.)
- `ghostty/` → `~/.config/ghostty` — Ghostty terminal config (Rose Pine + custom pink, glass blur)

## Install on a fresh machine

```sh
git clone <your-remote> ~/Dotfiles
cd ~/Dotfiles && ./install.sh
```

The installer is idempotent — running it twice is safe. For each managed path:

- if it's already the correct symlink → skip
- if it's a different symlink → relink
- if it's a real file/dir → back it up to `<path>.backup.<timestamp>`, then symlink
- if nothing exists there → just symlink

## Adding a new app

1. Move (or copy) the app's config into `~/Dotfiles/<app>/`.
2. Add one line to the `LINKS` array in `install.sh`:
   ```bash
   "<app>:$HOME/.config/<app>"
   ```
   For dotfiles in `$HOME` directly, point at the file:
   ```bash
   "zsh/.zshrc:$HOME/.zshrc"
   ```
3. Run `./install.sh`.
4. Commit.

## Uninstall

Remove the symlink (`rm ~/.config/<app>`). If you want the previous content back, the
installer left a `<path>.backup.<timestamp>` next to it.

## Per-app notes

### Neovim

- First `nvim` launch: lazy.nvim self-installs and pulls every plugin. Wait for it,
  quit, relaunch. Run `:Mason` to confirm LSP servers and formatters installed.
- Requires a Nerd Font for icons. JetBrainsMono Nerd Font is set in `ghostty/config`.
- For C/C++ projects, generate `compile_commands.json` (CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`)
  so `clangd` understands your build.

### Ghostty

- The pink (`#a85e7a`) background, `0.70` opacity, and macOS glass blur are deliberate
  — Neovim is configured with a transparent background to show this through.
