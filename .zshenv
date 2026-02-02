# =============================================================================
# ZSH Environment Variables
# =============================================================================
# This file is sourced on all invocations of the shell.
# Keep it minimal - only environment variables should be set here.

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Language and Locale
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
#export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
#export LC_ALL=""

# History
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=50000
export SAVEHIST=50000

# Path configuration
typeset -U path PATH

# Homebrew (macOS)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Local binaries
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
  path=("$PYENV_ROOT/bin" $path)
fi

# rbenv
if [[ -d "$HOME/.rbenv" ]]; then
  path=("$HOME/.rbenv/bin" $path)
fi

# Node.js (fnm)
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# Rust/Cargo
if [[ -d "$HOME/.cargo" ]]; then
  path=("$HOME/.cargo/bin" $path)
fi

# Go
export GOPATH="${GOPATH:-$HOME/go}"
if [[ -d "$GOPATH" ]]; then
  path=("$GOPATH/bin" $path)
fi

# Android SDK (macOS)
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path=(
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"
    $path
  )
fi

# Google Cloud SDK
if [[ -d "$HOME/google-cloud-sdk" ]]; then
  path=("$HOME/google-cloud-sdk/bin" $path)
fi

# Flutter
if [[ -d "/usr/local/lib/flutter" ]]; then
  path=("/usr/local/lib/flutter/bin" $path)
fi

export PATH
. "$HOME/.cargo/env"

# =============================================================================
# Local Configuration
# =============================================================================
# Source local config if it exists (for machine-specific settings)
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
