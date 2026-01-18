# =============================================================================
# Modern ZSH Configuration
# =============================================================================

# Ensure history directory exists
[[ -d "${XDG_STATE_HOME}/zsh" ]] || mkdir -p "${XDG_STATE_HOME}/zsh"

# =============================================================================
# Zinit Plugin Manager
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install zinit if not present
if [[ ! -d "$ZINIT_HOME" ]]; then
  print -P "%F{33}Installing zinit...%f"
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
# Prompt - Starship
# =============================================================================
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# =============================================================================
# Essential Plugins
# =============================================================================

# Syntax highlighting (load early)
zinit light zsh-users/zsh-syntax-highlighting

# Auto-suggestions based on history
zinit light zsh-users/zsh-autosuggestions

# Better completions
zinit light zsh-users/zsh-completions

# History substring search
zinit light zsh-users/zsh-history-substring-search

# Improved directory navigation
zinit light agkozak/zsh-z

# =============================================================================
# Modern CLI Tools
# =============================================================================
# These tools should be installed via your system's package manager:
#   macOS:  brew install fzf eza zoxide fd ripgrep bat git-delta lazygit
#   Ubuntu: sudo apt install fzf fd-find ripgrep bat
#           # eza, zoxide, delta, lazygit: install from GitHub releases or cargo
#   Arch:   sudo pacman -S fzf eza zoxide fd ripgrep bat git-delta lazygit

# fzf integration (if installed)
if command -v fzf &> /dev/null; then
  # Source fzf keybindings and completion
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  # Homebrew location
  [[ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell/key-bindings.zsh" ]] && \
    source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell/key-bindings.zsh"
  [[ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell/completion.zsh" ]] && \
    source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell/completion.zsh"
fi

# zoxide integration (if installed)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# =============================================================================
# Completions
# =============================================================================

# Remove non-existent directories from fpath
fpath=(${fpath:#/usr/local/share/zsh/site-functions})
fpath=($^fpath(N))

autoload -Uz compinit
# Use -u to ignore insecure directories, -C to skip security check for speed
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -u
else
  compinit -u -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# =============================================================================
# History Settings
# =============================================================================
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions

# =============================================================================
# Key Bindings
# =============================================================================
bindkey -e  # Emacs keybindings

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# fzf keybindings
if command -v fzf &> /dev/null; then
  # CTRL-R - Paste the selected command from history into the command line
  bindkey '^R' fzf-history-widget 2>/dev/null || true
fi

# =============================================================================
# Aliases
# =============================================================================

# Core aliases
alias vim="nvim"
alias vi="nvim"
alias g="git"

# Modern replacements (if available)
if command -v eza &> /dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --group-directories-first --git"
  alias la="eza -a --icons --group-directories-first"
  alias lt="eza --tree --icons --group-directories-first -L 2"
  alias lta="eza --tree --icons --group-directories-first -a -L 2"
else
  alias ll="ls -la"
  alias la="ls -a"
fi

if command -v bat &> /dev/null; then
  alias cat="bat --paging=never"
  alias catp="bat"
fi

if command -v fd &> /dev/null; then
  alias find="fd"
fi

if command -v rg &> /dev/null; then
  alias grep="rg"
fi

# zellij aliases
alias zj="zellij"
alias zja="zellij attach"
alias zjl="zellij list-sessions"

# Git shortcuts
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gst="git status"
alias gd="git diff"
alias gpl="git pull"
alias gps="git push"
alias gl="git log --oneline --graph --decorate -10"
alias gla="git log --oneline --graph --decorate --all"

# Useful shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias mkdir="mkdir -p"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# =============================================================================
# Tool Initializations
# =============================================================================

# pyenv
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
  if command -v pyenv-virtualenv-init &> /dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# rbenv
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init - zsh)"
fi

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# =============================================================================
# fzf Configuration
# =============================================================================
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
"

if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
fi

# =============================================================================
# Local Configuration
# =============================================================================
# Source local config if it exists (for machine-specific settings)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
