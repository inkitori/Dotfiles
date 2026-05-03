# Neovim Config

A from-scratch, hand-rolled Neovim IDE setup using **lazy.nvim** as the plugin
manager. No distro (no LazyVim, NvChad, AstroNvim) — every line is yours to
read, change, or delete.

> **lazy.nvim** is the plugin *manager* (like npm or pip).
> **LazyVim** is a separate, preconfigured *distro* built on top of it.
> Despite the names, this config is the former, not the latter.

---

## Layout

```
nvim/
├── init.lua                 -- entrypoint; loads everything below
├── lazy-lock.json           -- locks every plugin to a specific commit (auto-generated)
└── lua/
    ├── config/
    │   ├── options.lua      -- vim.opt settings (line numbers, indent, etc.)
    │   ├── keymaps.lua      -- non-plugin keymaps (window nav, save/quit, etc.)
    │   ├── autocmds.lua     -- autocommands (transparency, yank highlight, trim ws)
    │   └── lazy.lua         -- bootstraps lazy.nvim and tells it where plugins live
    └── plugins/             -- one file per plugin spec; lazy.nvim auto-imports all
        ├── colorscheme.lua
        ├── lsp.lua
        ├── completion.lua
        ├── treesitter.lua
        ├── telescope.lua
        ├── neo-tree.lua
        ├── lualine.lua
        ├── bufferline.lua
        ├── gitsigns.lua
        ├── conform.lua
        ├── nvim-lint.lua
        ├── autopairs.lua
        ├── which-key.lua
        ├── indent-blankline.lua
        ├── trouble.lua
        └── toggleterm.lua
```

The `nvim/` directory is symlinked to `~/.config/nvim` by the dotfiles
installer — so editing files here takes effect immediately.

---

## Plugin specs vs plugins

Every file under `lua/plugins/` is a **spec**, not a plugin. A spec is a small
Lua recipe — usually 5–30 lines — that tells lazy.nvim:

- *which* GitHub repo to clone (`"owner/repo"`)
- *when* to load it (`event`, `cmd`, `keys`, `ft`, or `lazy = false`)
- *how* to configure it (`opts = {}` or `config = function() … end`)

The actual plugin code lives at `~/.local/share/nvim/lazy/<plugin-name>/` after
lazy.nvim clones it. You don't write plugins from scratch; you write the
recipe that says "install this and pass it these options."

### Lazy-load triggers

| Field | Loads when… |
|---|---|
| `event = "VimEnter"` | Neovim has finished starting up |
| `event = "VeryLazy"` | Lazy's idle event (after UI is ready) |
| `event = "BufReadPost"` | A real file has been read |
| `event = "InsertEnter"` | You enter insert mode |
| `cmd = "Foo"` | You run `:Foo` |
| `keys = { "<leader>x", … }` | You press the key |
| `ft = "python"` | You open a `.py` file |
| `lazy = false` | Always; load on startup (use sparingly) |

The colorscheme has `lazy = false` and `priority = 1000` so it loads first;
everything else lazy-loads on demand.

---

## Daily-driver keymaps

Leader is **Space**. Every leader sequence is shown by **which-key** when you
press `<Space>` and pause briefly — that popup is your live cheat sheet.

Press `<Space>?` to see only the keymaps active in the current buffer (handy
when LSP-attached buffers add their own bindings).

### Files & navigation

| Keys | Action |
|---|---|
| `<Space>e` | Toggle Neo-tree explorer (sidebar) |
| `<Space>E` | Reveal current file in Neo-tree |
| `<Space>fe` | Floating Neo-tree |
| `<Space>ff` | Find files (fuzzy) |
| `<Space>fg` | Live grep across project |
| `<Space>fb` | Buffer list |
| `<Space>fr` | Recent files |
| `<Space>fh` | Help tags |
| `<Space>fk` | Browse all keymaps fuzzy |
| `<Space>/` | Fuzzy search inside current buffer |
| `Shift+h` / `Shift+l` | Previous/next buffer (bufferline) |
| `<Space>bd` | Delete current buffer |
| `<Space>bp` | Pin buffer |

Inside Neo-tree (when it's focused):

| Keys | Action |
|---|---|
| `l` | Open node |
| `h` | Close node |
| `a` | Add file/dir |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `?` | Show all bindings |

### LSP (code intelligence)

These activate only in buffers where a language server attached. Confirm with
`:LspInfo`.

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Hover docs |
| `Ctrl+k` (insert) | Signature help |
| `<Space>rn` | Rename symbol everywhere |
| `<Space>ca` | Code action (auto-imports, quick fixes) |
| `<Space>cf` | Format buffer |
| `<Space>tf` | Toggle format-on-save globally |
| `]d` / `[d` | Next / prev diagnostic |
| `<Space>cd` | Show diagnostic float for current line |
| `<Space>fs` | Document symbols (fuzzy outline) |
| `<Space>fS` | Workspace symbols (fuzzy across project) |
| `<Space>fd` | Diagnostics (fuzzy across project) |

### Diagnostics (Trouble)

| Keys | Action |
|---|---|
| `<Space>xx` | Diagnostics for whole project |
| `<Space>xX` | Diagnostics for current buffer only |
| `<Space>xs` | Symbols outline |
| `<Space>xl` | LSP refs/defs panel |
| `<Space>xL` | Location list |
| `<Space>xQ` | Quickfix list |

### Git (gitsigns)

| Keys | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hs` | Stage hunk (works in visual mode too) |
| `<Space>hr` | Reset hunk |
| `<Space>hS` | Stage entire buffer |
| `<Space>hu` | Undo last stage hunk |
| `<Space>hb` | Blame current line (full) |
| `<Space>hd` | Diff this file |

### Completion (blink.cmp)

The completion menu pops automatically as you type.

| Keys | Action |
|---|---|
| `Ctrl+n` / `Ctrl+p` | Next / prev item |
| `Tab` | Accept selected item |
| `Ctrl+e` | Cancel menu |
| `Ctrl+space` | Manually trigger menu |

### Terminal & windows

| Keys | Action |
|---|---|
| `<Space>tt` or `Ctrl+\` | Floating terminal (toggle) |
| `<Space>th` | Horizontal split terminal |
| `<Space>tv` | Vertical split terminal |
| `Ctrl+h/j/k/l` | Move between split windows |
| `Ctrl+arrows` | Resize current split |

In terminal mode: `Ctrl+\` toggles the floating terminal closed; `Ctrl+\` then
`Ctrl+n` enters normal mode so you can scroll/yank.

### Niceties

| Keys | Action |
|---|---|
| `<Space>w` | Save (`:w`) |
| `<Space>q` | Quit (`:q`) |
| `<Space>?` | Show keymaps for current buffer (which-key) |
| `<Esc>` | Clear search highlight |
| `n` / `N` | Next / prev search match (centered + zv) |
| Visual `J` / `K` | Move selection down / up |
| Visual `<` / `>` | Indent left / right, keep selection |
| `Ctrl+space` (normal) | Treesitter incremental selection |

---

## Daily workflow

1. **Open a project**: `nvim .` in its root. Neo-tree opens on the directory.
2. **Find a file**: `<Space>ff`, type a few letters, Enter.
3. **Search code**: `<Space>fg`, type your query, Enter on a hit.
4. **Edit**: completion is automatic; LSP errors/warnings appear in the gutter
   and inline.
5. **Format**: happens on save. Toggle off with `<Space>tf` if you need to
   commit a "WIP" without touching whitespace.
6. **Stage hunks**: `<Space>hs` on each hunk, then commit from a `:terminal`
   (`<Space>tt`) or in another shell.
7. **Multiple files**: `Shift+h` / `Shift+l` to cycle the bufferline; `<Space>fb`
   to fuzzy-jump.

When unsure: press `<Space>` and read the which-key popup, or run
`:Telescope keymaps` to fuzzy-search every binding.

---

## Plugin management

Run `:Lazy` for the plugin manager UI.

| Key | Action |
|---|---|
| `I` | Install missing plugins |
| `U` | Update all plugins to latest |
| `S` | Sync (install + update + clean) |
| `X` | Clean — remove plugins no longer in your specs |
| `C` | Check for updates (without installing) |
| `L` | Profile load times |
| `R` | Reload changed specs |
| `?` | Help |
| `q` | Close UI |

Run `:Lazy U` weekly. Lockfile (`lazy-lock.json`) is committed to git, so a
fresh machine reproduces the same plugin commit hashes.

### Mason (LSP servers / formatters / linters)

`:Mason` opens a UI to install/update/remove the binaries used by `nvim-lspconfig`,
`conform.nvim`, and `nvim-lint`. Mason auto-installs everything in your
`ensure_installed` list on startup, so you usually don't need to touch it.

If first-launch installs haven't completed and you're seeing missing-tool
errors, run `:MasonToolsInstall` and wait for the bottom-of-screen progress
to settle.

### Treesitter parsers

Run `:TSUpdate` to update parsers (the per-language syntax modules). New
parsers auto-install for filetypes in `ensure_installed` (in
`plugins/treesitter.lua`).

---

## Adding / removing / configuring plugins

### Add a plugin

1. Create `lua/plugins/<name>.lua`:
   ```lua
   return {
     "github-owner/repo-name",
     event = "VeryLazy",       -- or `cmd = "..."`, `keys = {...}`, `ft = "..."`
     opts = {},                -- passed to require("repo-name").setup(opts)
   }
   ```
2. Quit and relaunch `nvim`. lazy.nvim auto-detects the new file and clones.
3. (Optional) `:Lazy` to confirm it loaded.

### Remove a plugin

Delete the file, then `:Lazy clean`.

### Change a plugin's config

Edit its file under `lua/plugins/`. Changes apply on next launch (or
`:Lazy reload <name>`).

### Add a keymap to an existing plugin

Edit the plugin's spec and add to its `keys = { … }` array:
```lua
keys = {
  { "<leader>xk", "<cmd>SomeCommand<CR>", desc = "Do thing" },
},
```

---

## Transparency & line numbers — how they work

### Hybrid line numbers

Set in `lua/config/options.lua`:
```lua
opt.number = true          -- absolute number on current line
opt.relativenumber = true  -- relative numbers on every other line
```

### Transparent background

Two layers cooperate:

1. **Colorscheme option** (`lua/plugins/colorscheme.lua`):
   ```lua
   require("rose-pine").setup({ styles = { transparency = true } })
   ```

2. **`ColorScheme` autocmd** (`lua/config/autocmds.lua`) — defensively clears
   ~30 highlight groups (Normal, NormalFloat, FloatBorder, all Telescope/
   NeoTree/WhichKey/Trouble/Pmenu groups) every time a colorscheme loads.
   This catches plugins that re-paint backgrounds inside their floating
   windows.

The result: Neovim paints no background, so Ghostty's pink + glass blur shows
through every pane. Verify with `:hi Normal` — should report `cleared` or
`guibg=NONE`.

If you ever see an opaque pane, find its highlight group with
`:hi <GroupName>` (after spawning the offending UI) and add the group name to
the autocmd's list in `lua/config/autocmds.lua`.

---

## Troubleshooting

| Symptom | Try |
|---|---|
| Plugin won't load | `:Lazy` → check the plugin's status, then `:messages` |
| LSP didn't attach | `:LspInfo`, `:Mason` (server installed?), check filetype matches |
| Format on save not running | `:ConformInfo` shows configured formatter; `<Space>tf` toggles |
| Lint not running | `:lua print(vim.inspect(require("lint").linters_by_ft))` then check `:Mason` |
| Treesitter parser missing | `:TSUpdate` or `:TSInstall <lang>` |
| `nvim-treesitter.configs` not found | We pin `branch = "master"` — check your spec didn't drift |
| Telescope crashes | `:checkhealth telescope` — usually a missing `ripgrep`/`fd` |
| Slow startup | `:Lazy profile` to see load times |
| Colorscheme broken | `:colorscheme rose-pine` manually; check `termguicolors` is on |
| Backgrounds aren't transparent | `:hi Normal` — if it has a `bg`, find which colorscheme/plugin set it |

### Useful diagnostic commands

- `:checkhealth` — top-level diagnostic; runs every plugin's self-test
- `:checkhealth lazy` / `:checkhealth mason` / `:checkhealth nvim-treesitter`
- `:Lazy` — plugin status
- `:Mason` — LSP/formatter/linter status
- `:LspInfo` — LSPs attached to current buffer (and why not, if not)
- `:ConformInfo` — formatter status for current buffer
- `:messages` — recent nvim messages
- `:set filetype?` — what nvim thinks this file is

### Reading plugin docs

The actual plugin source is at `~/.local/share/nvim/lazy/<plugin>/`. README
and `:help <plugin>` work for most plugins. From inside nvim:

```vim
:help telescope
:help lazy.nvim
:help neo-tree
```

---

## Languages set up out of the box

| Language | LSP | Formatter | Linter |
|---|---|---|---|
| Lua | `lua_ls` | `stylua` | (LSP) |
| Python | `pyright` | `ruff_format` | `ruff` |
| TypeScript / JavaScript | `ts_ls` | `prettier` | `eslint_d` |
| C / C++ | `clangd` | `clang-format` | `clangd` (clang-tidy) |

To add a language: open `lua/plugins/lsp.lua` and add to the
`ensure_installed` array, then add formatters/linters in `conform.lua` and
`nvim-lint.lua`.

For C/C++ projects, generate `compile_commands.json` so clangd understands
your build:
- CMake: build with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
- Make: `bear -- make` (install via `brew install bear`)

---

## See also

- `~/Dotfiles/README.md` — top-level dotfiles repo overview
- `~/Dotfiles/bootstrap.sh` — installs the CLI tools this config expects
- `~/Dotfiles/install.sh` — symlinks configs into place
- [lazy.nvim docs](https://lazy.folke.io/)
- [Neovim user manual](https://neovim.io/doc/user/) (or `:help` inside nvim)
