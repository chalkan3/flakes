# ═══════════════════════════════════════════════════════════════════════
# 🔌 Zinit Plugin Manager Configuration
# ═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# Zinit Annexes (extensions)
# ───────────────────────────────────────────────────────────────────────
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ───────────────────────────────────────────────────────────────────────
# 🎨 Theme
# ───────────────────────────────────────────────────────────────────────
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ───────────────────────────────────────────────────────────────────────
# 🚀 Performance & Completions (loaded with turbo for speed)
# ───────────────────────────────────────────────────────────────────────
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# ───────────────────────────────────────────────────────────────────────
# 🎯 Syntax Highlighting (must be loaded last)
# ───────────────────────────────────────────────────────────────────────
zinit ice wait lucid atinit'zicompinit; zicdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting

# ───────────────────────────────────────────────────────────────────────
# 📚 History & Search
# ───────────────────────────────────────────────────────────────────────
zinit light zsh-users/zsh-history-substring-search

# Bind keys for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# ───────────────────────────────────────────────────────────────────────
# ✨ Modern Enhancements
# ───────────────────────────────────────────────────────────────────────

# fzf-tab: Replace default completions with fzf
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Configure fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd -1 --color=always $realpath'

# zsh-autopair: Auto close brackets, quotes, etc
zinit ice wait lucid
zinit light hlissner/zsh-autopair

# zsh-you-should-use: Reminds you to use aliases
zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use

# ───────────────────────────────────────────────────────────────────────
# 🔧 CLI Tools Initialization
# ───────────────────────────────────────────────────────────────────────
# Install these tools via your package manager:
#
# macOS (Homebrew):
#   brew install zoxide eza bat fd ripgrep git-delta direnv fzf
#
# Ubuntu/Debian:
#   sudo apt install zoxide eza bat fd-find ripgrep git-delta direnv fzf
#   Note: fd-find creates 'fdfind' - create alias: ln -s $(which fdfind) ~/.local/bin/fd
#
# Arch Linux:
#   sudo pacman -S zoxide eza bat fd ripgrep git-delta direnv fzf

# zoxide: Smarter cd
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# direnv: Auto load environment variables
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# ───────────────────────────────────────────────────────────────────────
# 🔧 Utilities
# ───────────────────────────────────────────────────────────────────────

# async: Async job execution
zinit light mafredri/zsh-async

# colored-man-pages: Man pages com cores
zinit ice wait lucid
zinit light ael-code/zsh-colored-man-pages

# zsh-interactive-cd: CD interativo com fzf
zinit ice wait lucid
zinit light changyuheng/zsh-interactive-cd
