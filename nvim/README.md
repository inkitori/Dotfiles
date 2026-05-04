# Neovim Config

Hand-rolled Neovim setup managed by **lazy.nvim**. No distro.

The `nvim/` directory is symlinked to `~/.config/nvim` by the dotfiles installer.

---

## Plugins at a glance

| Plugin | What it does |
|---|---|
| **lazy.nvim** | Plugin manager. `:Lazy` for the UI. |
| **rose-pine** | Colorscheme (transparent so Ghostty's pink shows through). |
| **neo-tree** | File explorer sidebar. |
| **telescope** | Fuzzy finder for files, code, buffers, symbols. |
| **bufferline** | The "tab strip" along the top — really a list of open buffers. |
| **lualine** | Status line at the bottom. |
| **nvim-lspconfig** | Wires up language servers (definitions, hover, rename, etc.). |
| **mason** | Installs LSP servers, formatters, linters. `:Mason`. |
| **blink.cmp** | Autocomplete as you type. |
| **nvim-treesitter** | Syntax-aware highlighting and structural selection. |
| **conform.nvim** | Format-on-save (prettier, ruff, stylua, clang-format). |
| **nvim-lint** | Linters (eslint_d, ruff). |
| **gitsigns** | Git change markers in the gutter; hunk staging. |
| **trouble** | Diagnostics / references panel. |
| **toggleterm** | Floating and split terminals. |
| **which-key** | Press `<Space>` and pause — popup shows every leader binding. |
| **autopairs** | Auto-closes brackets and quotes. |
| **indent-blankline** | Indentation guides. |

---

## Quick start

```sh
cd some-repo
nvim .
```

Leader is **Space**. The bare-minimum keys:

| Goal | Keys |
|---|---|
| Open file by name (fuzzy) | `<Space>ff` |
| Search code across the project | `<Space>fg` |
| Switch between open files (fuzzy) | `<Space>fb` |
| Cycle through open files | `Shift+h` / `Shift+l` |
| Toggle the file tree sidebar | `<Space>e` |
| Save | `<Space>w` |
| Close the current file ("tab") | `<Space>bd` |
| **Quit Neovim entirely** | `:qa` (or `:qa!` to discard unsaved) |

When unsure: press `<Space>` and pause — which-key shows every binding. Or `<Space>fk` to fuzzy-search them all.

---

## Buffers vs windows — why `:q` doesn't actually quit

The "tabs" at the top are **buffers** (loaded files), not Vim tabs. Three things to keep separate:

- **Buffer** — a loaded file. Listed in the bufferline. Close with `<Space>bd` or `:bd`.
- **Window** — a viewport showing a buffer. `:q` closes a window. The buffer stays loaded.
- **Tab page** — a layout of windows (we don't use these).

So `:q` only closes the pane your cursor is in. If neo-tree or another split is still open, nvim stays running. To exit everything:

| Command | Action |
|---|---|
| `:qa` | Quit all windows (exit nvim) |
| `:qa!` | Quit all, discard unsaved changes |
| `:wqa` | Save all, then quit |
| `<Space>bd` | Close just the current "tab" (buffer), keep nvim open |

---

## Inside files

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<Space>rn` | Rename symbol project-wide |
| `<Space>ca` | Code action (quick fix, auto-import) |
| `<Space>cf` | Format buffer |
| `]d` / `[d` | Next / prev diagnostic |
| `<Space>cd` | Show diagnostic for current line |

---

## Inside the file tree

Focus the tree (`<Space>e` to toggle, `Ctrl+h` to jump from the file pane).

| Keys | Action |
|---|---|
| `l` / `h` | Open/expand, collapse |
| `a` / `d` / `r` / `c` / `m` | Add / delete / rename / copy / move |
| `f` | Filter — type query, Enter, navigate filtered list |
| `<C-x>` | Clear filter |
| `H` | Toggle hidden files |
| `?` | Show every neo-tree binding |

In the filter input: `Ctrl+W` deletes a word, `Ctrl+U` clears the line.

---

## Git (gitsigns)

| Keys | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hs` | Stage hunk (works in visual mode for partial stages) |
| `<Space>hr` | Reset hunk |
| `<Space>hb` | Blame current line |
| `<Space>hd` | Diff this file |

---

## Splits and terminal

| Keys | Action |
|---|---|
| `Ctrl+h/j/k/l` | Move between split windows |
| `Ctrl+arrows` | Resize current split |
| `<Space>tt` or `Ctrl+\` | Floating terminal |
| `<Space>th` / `<Space>tv` | Horizontal / vertical split terminal |

In terminal mode: `Ctrl+\` toggles closed; `Ctrl+\` then `Ctrl+n` enters normal mode (scroll/yank).

---

## Plugin management

- `:Lazy` — install / update / clean plugins (press `?` inside for keys)
- `:Mason` — install / update LSP servers, formatters, linters
- `:checkhealth` — diagnose anything broken

Lockfile (`lazy-lock.json`) is committed, so a fresh machine reproduces the same plugin versions.

---

## Layout

```
nvim/
├── init.lua                 -- entrypoint
├── lazy-lock.json           -- pinned plugin commits
└── lua/
    ├── config/              -- options, keymaps, autocmds, lazy bootstrap
    └── plugins/             -- one file per plugin spec
```

Edit any file under `lua/plugins/` to reconfigure a plugin; changes apply on next launch.
