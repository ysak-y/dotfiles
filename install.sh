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
# Claude Code MCP Configuration Sync
# =============================================================================
print_header "Syncing Claude Code MCP configuration"

CLAUDE_JSON="$HOME/.claude.json"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

if [[ -f "$CLAUDE_SETTINGS" ]]; then
  if command -v jq &> /dev/null; then
    # Extract mcpServers from settings.json
    MCP_SERVERS=$(jq '.mcpServers' "$CLAUDE_SETTINGS")

    if [[ "$MCP_SERVERS" != "null" ]]; then
      if [[ -f "$CLAUDE_JSON" ]]; then
        # Backup .claude.json
        cp "$CLAUDE_JSON" "${CLAUDE_JSON}.backup.$(date +%Y%m%d%H%M%S)"

        # Merge mcpServers into .claude.json
        jq --argjson servers "$MCP_SERVERS" '.mcpServers = $servers' "$CLAUDE_JSON" > "${CLAUDE_JSON}.tmp" && mv "${CLAUDE_JSON}.tmp" "$CLAUDE_JSON"

        print_success "Synced mcpServers from ~/.claude/settings.json to ~/.claude.json"
        print_warning "Please restart Claude Code to apply MCP server changes"
      else
        print_warning "~/.claude.json does not exist yet (will be created on first Claude Code launch)"
        print_warning "Run ./install.sh again after launching Claude Code once"
      fi
    else
      print_warning "No mcpServers found in ~/.claude/settings.json"
    fi
  else
    print_warning "jq not found. Install jq to sync MCP configuration: brew install jq"
  fi
else
  print_warning "~/.claude/settings.json not found (symlink may not be created yet)"
fi

# =============================================================================
# git-ai-commit Configuration
# =============================================================================
print_header "Installing git-ai-commit configuration"

mkdir -p "$HOME/.config/git-ai-commit"
create_link "$DOTFILES_DIR/git-ai-commit/config.toml" "$HOME/.config/git-ai-commit/config.toml"
create_link "$DOTFILES_DIR/git-ai-commit/prompts" "$HOME/.config/git-ai-commit/prompts"

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
  print_warning "npm not found. Install Node.js (nodenv) first, then re-run install.sh"
fi

# =============================================================================
# git-ai-commit Installation (AI-powered commit messages)
# =============================================================================
print_header "Installing git-ai-commit"

if command -v brew &> /dev/null; then
  # Tap repository if not already tapped
  if ! brew tap | grep -q "takai/tap"; then
    brew tap takai/tap
    print_success "Tapped takai/tap repository"
  fi

  # Install git-ai-commit
  if ! command -v git-ai-commit &> /dev/null; then
    brew install git-ai-commit
    print_success "Installed git-ai-commit"
  else
    print_success "git-ai-commit already installed"
  fi
else
  print_warning "Homebrew not found. Install Homebrew first, then re-run install.sh"
fi

# =============================================================================
# uv Installation (Python package manager for MCP servers)
# =============================================================================
print_header "Installing uv (Python package manager)"

if command -v uv &> /dev/null; then
  print_success "uv already installed ($(uv --version))"
else
  if command -v brew &> /dev/null; then
    brew install uv
    print_success "Installed uv via Homebrew"
  elif command -v curl &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    print_success "Installed uv package manager"
  else
    print_warning "brew/curl not found. Install manually: https://docs.astral.sh/uv/"
  fi
fi

# =============================================================================
# nodenv Installation (Node.js version manager)
# =============================================================================
print_header "Installing nodenv"

if command -v brew &> /dev/null; then
  # Install nodenv
  if ! command -v nodenv &> /dev/null; then
    brew install nodenv
    print_success "Installed nodenv"
  else
    print_success "nodenv already installed"
  fi

  # Install node-build plugin (for installing Node versions)
  if ! brew list node-build &> /dev/null 2>&1; then
    brew install node-build
    print_success "Installed node-build"
  else
    print_success "node-build already installed"
  fi
else
  print_warning "Homebrew not found. Install Homebrew first, then re-run install.sh"
fi

# =============================================================================
# rails-mcp-server Installation (Rails MCP server for Claude)
# =============================================================================
print_header "Installing rails-mcp-server"

if command -v gem &> /dev/null; then
  # Check Ruby version (requires 3.1+)
  RUBY_VERSION=$(ruby -e 'print RUBY_VERSION')
  RUBY_MAJOR=$(echo $RUBY_VERSION | cut -d. -f1)
  RUBY_MINOR=$(echo $RUBY_VERSION | cut -d. -f2)

  if [[ $RUBY_MAJOR -lt 3 ]] || [[ $RUBY_MAJOR -eq 3 && $RUBY_MINOR -lt 1 ]]; then
    print_warning "rails-mcp-server requires Ruby 3.1+, current: $RUBY_VERSION"
    print_warning "Install Ruby 3.1+ with: rbenv install 3.3.0 && rbenv global 3.3.0"
  else
    # Check if rails-mcp-server is already installed
    if gem list rails-mcp-server -i &> /dev/null; then
      print_success "rails-mcp-server already installed ($(gem list rails-mcp-server | grep rails-mcp-server))"
    else
      gem install rails-mcp-server
      print_success "Installed rails-mcp-server"
    fi

    # Create rails-mcp config directory and projects.yml if needed
    mkdir -p "$HOME/.config/rails-mcp"
    if [[ ! -f "$HOME/.config/rails-mcp/projects.yml" ]]; then
      echo "# Rails MCP Server Projects" > "$HOME/.config/rails-mcp/projects.yml"
      echo "# Add your Rails projects here:" >> "$HOME/.config/rails-mcp/projects.yml"
      echo "# myapp: \"/path/to/myapp\"" >> "$HOME/.config/rails-mcp/projects.yml"
      print_success "Created ~/.config/rails-mcp/projects.yml (add your projects here)"
    fi
  fi
else
  print_warning "gem not found. Install Ruby first, then re-run install.sh"
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
echo "  - uv (Python package manager for Serena MCP)"
echo ""
echo -e "${BLUE}Quick install (macOS with Homebrew):${NC}"
echo "  brew install zsh neovim zellij starship fzf fd ripgrep eza bat zoxide lazygit gh nodenv node-build"
echo ""
echo -e "${BLUE}Quick install (Linux):${NC}"
echo "  # Most tools will be auto-installed by zinit on first zsh launch"
echo "  # For system packages, use your distribution's package manager"
echo ""
