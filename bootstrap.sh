#!/usr/bin/env bash
# bootstrap.sh — install the CLI toolchain this dotfiles repo expects.
# Run once on a fresh machine, then run `./install.sh` to symlink configs.
#
# Idempotent: re-running is safe; existing tools are skipped.

set -euo pipefail

log()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m!!\033[0m  %s\n" "$*" >&2; }
ok()   { printf "\033[1;32m✓\033[0m   %s\n" "$*"; }

# ----------------------------------------------------------------------------
# 1. Homebrew
# ----------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Make brew available immediately on Apple Silicon
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  ok "Homebrew already installed"
fi

# ----------------------------------------------------------------------------
# 2. Brew formulas (CLI tools)
# ----------------------------------------------------------------------------
BREW_FORMULAS=(
  neovim          # the editor
  ripgrep         # required by Telescope live_grep
  fd              # faster find (used by Telescope)
  fzf             # fuzzy finder
  zoxide          # smarter cd
  eza             # modern ls
  bat             # modern cat
  starship        # prompt
  direnv          # auto-load .envrc per project
  fastfetch       # terminal greeting
  yt-dlp          # youtube downloader
  jq              # json filter — handy
  git             # in case we're on a really fresh machine
  llvm            # clang, clang-format, clangd (used by nvim's clangd LSP)
  node            # for many LSP servers + prettier + eslint_d
)

log "Installing brew formulas…"
for f in "${BREW_FORMULAS[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then
    ok "$f already installed"
  else
    log "brew install $f"
    brew install "$f"
  fi
done

# ----------------------------------------------------------------------------
# 3. Brew casks (apps)
# ----------------------------------------------------------------------------
BREW_CASKS=(
  ghostty                     # terminal
  font-jetbrains-mono-nerd-font  # icon font (Ghostty + Neovim use this)
)

log "Installing brew casks…"
for c in "${BREW_CASKS[@]}"; do
  if brew list --cask "$c" >/dev/null 2>&1; then
    ok "$c already installed"
  else
    log "brew install --cask $c"
    brew install --cask "$c"
  fi
done

# ----------------------------------------------------------------------------
# 4. uv (Python toolchain — replaces pyenv/conda for this user)
# ----------------------------------------------------------------------------
if command -v uv >/dev/null 2>&1; then
  ok "uv already installed"
else
  log "Installing uv…"
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ----------------------------------------------------------------------------
# 5. Done
# ----------------------------------------------------------------------------
echo
ok "Bootstrap complete."
echo
echo "Next steps:"
echo "  1) cd \"$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")\" && ./install.sh"
echo "  2) Open Ghostty, then run \`nvim\` once so lazy.nvim installs plugins."
echo "  3) Inside nvim: \`:MasonToolsInstall\` to install LSP servers + formatters."
