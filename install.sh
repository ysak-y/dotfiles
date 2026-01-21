#!/bin/bash
# =============================================================================
# Dotfiles Installation Script
# =============================================================================
# This script creates symbolic links for all dotfiles configurations.
# Run: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}==>${NC} ${1}"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} ${1}"
}

print_warning() {
    echo -e "  ${YELLOW}!${NC} ${1}"
}

print_error() {
    echo -e "  ${RED}✗${NC} ${1}"
}

# Create a symbolic link with backup
create_link() {
    local source="$1"
    local target="$2"
    local target_dir=$(dirname "$target")

    # Create target directory if it doesn't exist
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
    fi

    # Backup existing file/directory if it exists and is not a symlink
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        print_warning "Backed up existing ${target} to ${backup}"
    fi

    # Remove existing symlink
    if [[ -L "$target" ]]; then
        rm "$target"
    fi

    # Create symlink
    ln -s "$source" "$target"
    print_success "Linked ${source} -> ${target}"
}

# =============================================================================
# Main Installation
# =============================================================================

echo -e "${BLUE}"
echo "  ____        _    __ _ _           "
echo " |  _ \  ___ | |_ / _(_) | ___  ___ "
echo " | | | |/ _ \| __| |_| | |/ _ \/ __|"
echo " | |_| | (_) | |_|  _| | |  __/\__ \\"
echo " |____/ \___/ \__|_| |_|_|\___||___/"
echo -e "${NC}"
echo "Installing dotfiles from: $DOTFILES_DIR"

# =============================================================================
# ZSH Configuration
# =============================================================================
print_header "Installing ZSH configuration"

create_link "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
create_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Create zsh state directory
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

# =============================================================================
# Git Configuration
# =============================================================================
print_header "Installing Git configuration"

create_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# =============================================================================
# Neovim Configuration
# =============================================================================
print_header "Installing Neovim configuration"

mkdir -p "$HOME/.config"
create_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# =============================================================================
# Zellij Configuration
# =============================================================================
print_header "Installing Zellij configuration"

create_link "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"

# =============================================================================
# Starship Configuration
# =============================================================================
print_header "Installing Starship configuration"

create_link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# =============================================================================
# Claude Code Configuration
# =============================================================================
print_header "Installing Claude Code configuration"

mkdir -p "$HOME/.claude"
create_link "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

# =============================================================================
# Legacy Vim Configuration (optional)
# =============================================================================
print_header "Installing legacy Vim configuration"

if [[ -f "$DOTFILES_DIR/.vimrc" ]]; then
    create_link "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
fi

if [[ -d "$DOTFILES_DIR/colors" ]]; then
    mkdir -p "$HOME/.vim"
    create_link "$DOTFILES_DIR/colors" "$HOME/.vim/colors"
fi

# =============================================================================
# Agent Browser Installation (for Claude browser automation)
# =============================================================================
print_header "Installing Agent Browser"

if command -v npm &> /dev/null; then
  # Install agent-browser globally
  if ! command -v agent-browser &> /dev/null; then
    npm install -g agent-browser
    print_success "Installed agent-browser globally"
  else
    print_success "agent-browser already installed"
  fi

  # Install Chromium for agent-browser
  agent-browser install
  print_success "Installed Chromium for agent-browser"
else
  print_warning "npm not found. Install Node.js (fnm) first, then re-run install.sh"
fi

# =============================================================================
# Post-installation notes
# =============================================================================
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open Neovim and wait for plugins to install (automatic)"
echo "  3. Run :Mason in Neovim to install LSP servers"
echo ""
echo -e "${BLUE}Recommended tools to install:${NC}"
echo "  - zsh (shell)"
echo "  - neovim (editor)"
echo "  - zellij (terminal multiplexer)"
echo "  - starship (prompt)"
echo "  - fzf, fd, ripgrep, eza, bat, zoxide (modern CLI tools)"
echo "  - lazygit (git TUI)"
echo ""
echo -e "${BLUE}Quick install (macOS with Homebrew):${NC}"
echo "  brew install zsh neovim zellij starship fzf fd ripgrep eza bat zoxide lazygit gh"
echo ""
echo -e "${BLUE}Quick install (Linux):${NC}"
echo "  # Most tools will be auto-installed by zinit on first zsh launch"
echo "  # For system packages, use your distribution's package manager"
echo ""
