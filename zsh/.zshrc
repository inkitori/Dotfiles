# Silence zoxide's "init at end of file" warning — our ordering is fine
export _ZO_DOCTOR=0

# ============================================================================
# Editor
# ============================================================================
alias vim="nvim"
alias vi="nvim"

# ============================================================================
# PATH
# ============================================================================
# LLVM (clang, clang-format, clangd)
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# Personal scripts
export PATH="$HOME/bin:$PATH"

# ============================================================================
# Shell tooling
# ============================================================================
# direnv: auto-load .envrc in project dirs
eval "$(direnv hook zsh)"

# Starship prompt
eval "$(starship init zsh)"

# zoxide: smarter cd; alias `cd` to `z`
eval "$(zoxide init zsh)"
alias cd='z'

# fzf keybindings + completion
source <(fzf --zsh)

# ============================================================================
# Modern CLI replacements
# ============================================================================
alias ls='eza --icons --git'
alias ll='eza -lah --icons --git'
alias cat='bat'

# ============================================================================
# Misc aliases
# ============================================================================
alias ytmp3="yt-dlp -x --audio-format mp3"

# ============================================================================
# Claude shortcuts
# ============================================================================
alias ai='noglob claude_ai'
alias aic='noglob claude_aic'
alias aiq='noglob claude_aiq'

claude_ai()  { claude -p "$*"; }
claude_aic() { claude -c -p "$*"; }
claude_aiq() { claude -p --model haiku "$*"; }

# ============================================================================
# Greeting
# ============================================================================
fastfetch
