# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Installation and Setup

### Initial Installation
```bash
./install.sh
```

This script creates symlinks for all configurations with timestamped backups of existing files.

### Post-Installation Steps
1. Restart terminal or run: `source ~/.zshrc`
2. Open Neovim - plugins will auto-install via lazy.nvim
3. Inside Neovim, run `:Mason` to install LSP servers and tools

### Quick Install of Required Tools

**macOS (Homebrew):**
```bash
brew install zsh neovim zellij starship fzf fd ripgrep eza bat zoxide lazygit
```

**Linux:**
Most ZSH plugins auto-install via Zinit on first launch. For system packages, use your distribution's package manager:
```bash
# Ubuntu/Debian
sudo apt install fzf fd-find ripgrep bat

# Arch Linux
sudo pacman -S fzf eza zoxide fd ripgrep bat git-delta lazygit
```

## Repository Architecture

### Symlink-Based Configuration Management

This repository uses a symlink approach where configurations live in the dotfiles directory and are linked to their expected locations:

- Dotfiles directory: `/Users/yoshiakiyamada/dotfiles/`
- Symlinks created in: `$HOME/` and `$HOME/.config/`
- Backup strategy: Existing files are backed up as `<filename>.backup.<timestamp>` before being replaced

**What gets linked:**
- Shell configs: `.zshenv`, `.zshrc` → `$HOME/`
- Git config: `.gitconfig` → `$HOME/`
- Neovim: `nvim/` → `$HOME/.config/nvim/`
- Zellij: `zellij/` → `$HOME/.config/zellij/`
- Starship: `.config/starship.toml` → `$HOME/.config/starship.toml`
- Claude Code: `.claude/settings.json` → `$HOME/.claude/settings.json`

### XDG Base Directory Compliance

All configurations respect XDG Base Directory specification:
- `XDG_CONFIG_HOME` (default: `~/.config`) - Configuration files
- `XDG_DATA_HOME` (default: `~/.local/share`) - Data files (Zinit plugins, Neovim data)
- `XDG_STATE_HOME` (default: `~/.local/state`) - State files (ZSH history)
- `XDG_CACHE_HOME` (default: `~/.cache`) - Cache files

This means history, plugins, and data files are organized in standard locations rather than cluttering `$HOME`.

### Modular Plugin Architecture

**Neovim (`nvim/lua/plugins/*.lua`):**
Each file manages a specific concern:
- `colorscheme.lua` - Theme (Tokyo Night)
- `completion.lua` - nvim-cmp and snippets
- `editor.lua` - Text manipulation (surround, flash, gitsigns, fugitive)
- `lsp.lua` - LSP setup with Mason
- `telescope.lua` - Fuzzy finder
- `treesitter.lua` - Syntax parsing/highlighting
- `ui.lua` - File explorer (neo-tree), statusline (lualine), buffer line

**ZSH (`.zshrc` with Zinit):**
Plugin-based shell configuration:
- Auto-installs Zinit on first run if missing
- Loads plugins: syntax-highlighting, autosuggestions, completions, history-substring-search, zsh-z
- Conditional tool initialization (only loads if tool exists): fzf, zoxide, pyenv, rbenv

### Lazy Loading Strategy

**Performance optimization principle:** Both Neovim and ZSH use lazy loading to improve startup time.

**Neovim:**
- Uses lazy.nvim plugin manager
- Plugins specify when to load (on command, on filetype, on keys)
- Example: LSP loads on buffer read, Telescope on keybindings

**ZSH:**
- Completions load daily (24h cache via compinit)
- Plugins load in order (syntax highlighting last for correctness)
- Tool integrations only initialize if tools are installed

### Modern Tool Replacements

This configuration prefers modern CLI tools with better UX:
- `eza` replaces `ls` (with icons, git status, colors)
- `bat` replaces `cat` (syntax highlighting)
- `fd` replaces `find` (faster, better defaults)
- `rg` (ripgrep) replaces `grep` (faster, respects .gitignore)
- `zoxide` replaces `cd` (intelligent directory jumping)
- `delta` for git diffs (syntax-aware diff viewer)
- `lazygit` for git TUI

Aliases are conditionally set only if the modern tool is installed, falling back to traditional commands.

## Neovim Configuration

### Plugin Management

**Adding a new plugin:**
1. Create or edit a file in `nvim/lua/plugins/` (choose appropriate category)
2. Add plugin spec following lazy.nvim format:
   ```lua
   return {
     "author/plugin-name",
     dependencies = { "dep1", "dep2" },
     event = "VeryLazy",  -- or ft, cmd, keys for lazy loading
     config = function()
       require("plugin-name").setup({
         -- config here
       })
     end,
   }
   ```
3. Restart Neovim - lazy.nvim auto-installs on next launch

**Managing LSP servers:**
1. Open Neovim and run `:Mason`
2. Press `i` to install, `X` to uninstall
3. Common servers: pyright (Python), typescript-language-server, rust-analyzer, gopls
4. Mason also installs formatters (prettier, black, stylua) and linters (eslint, ruff)

**Plugin organization pattern:**
- Entry point: `nvim/init.lua` sets leader key, loads `config/` modules
- Core settings: `lua/config/options.lua`, `lua/config/keymaps.lua`, `lua/config/autocmds.lua`
- Plugin loader: `lua/config/lazy.lua` (bootstraps lazy.nvim)
- Plugin specs: `lua/plugins/*.lua` (auto-imported by lazy.nvim)

### Formatting and Linting

- Formatting: Uses `conform.nvim` (configured in `plugins/lsp.lua`)
- Linting: Uses `nvim-lint` (configured in `plugins/lsp.lua`)
- Formatters run automatically on save for supported file types
- LSP diagnostic integration via `trouble.nvim`

## ZSH Configuration

### Plugin Manager: Zinit

**Auto-installation:**
If Zinit is not found at `$XDG_DATA_HOME/zinit/zinit.git`, the `.zshrc` automatically clones it on first shell launch.

**Plugin loading order:**
1. Starship prompt (via zinit from GitHub releases)
2. zsh-syntax-highlighting (core functionality)
3. zsh-autosuggestions (history-based suggestions)
4. zsh-completions (additional completion definitions)
5. zsh-history-substring-search (up/down arrow search)
6. zsh-z (directory jumping based on frecency)

### Tool Integration

**Language version managers:**
The configuration supports multiple language version managers and initializes them if installed:
- pyenv (Python)
- rbenv (Ruby)
- nodebrew (Node.js alternative)
- Cargo (Rust)
- Go toolchain
- Google Cloud SDK

**Shell history:**
- Location: `$XDG_STATE_HOME/zsh/history`
- Size: 50,000 entries
- Behavior: Shared across all sessions, no duplicates, immediate append

### Local Configuration Override

Machine-specific settings can be added to `~/.zshrc.local` (not tracked in git). This file is automatically sourced at the end of `.zshrc` if it exists.

## Zellij Terminal Multiplexer

**Keybindings:**
- Alt + arrow keys: Navigate panes
- Alt + n/p: Next/previous tab
- Ctrl + t: Tab mode
- Ctrl + p: Pane mode
- Ctrl + h: Move mode

**Layouts:**
- `compact.kdl`: Minimal layout with compact tab bar
- `dev.kdl`: Development layout with multiple panes

**Session management:**
- `zellij` or `zj`: Start new session
- `zellij attach` or `zja`: Attach to existing session
- `zellij list-sessions` or `zjl`: List all sessions

## Shared Theme: Tokyo Night

All tools use consistent Tokyo Night color scheme:
- Neovim: tokyonight.nvim plugin
- Starship: Tokyo Night palette in `.config/starship.toml`
- Zellij: Tokyo Night theme in `zellij/config.kdl`
- fzf: Custom Tokyo Night colors in `.zshrc`

This creates visual consistency across terminal, prompt, editor, and multiplexer.

## Git Configuration

**Useful aliases (`.gitconfig`):**
- `git co` - checkout
- `git br` - branch
- `git pl` - pull
- `git st` - status
- `git fixup` - commit --amend --no-edit
- `git fetchpr <number>` - fetch PR by number
- `git copr <number>` - checkout PR by number
- `git ls` - log with custom format

## Testing Changes

### After modifying shell config:
```bash
source ~/.zshrc
# Verify no errors appear
```

### After modifying Neovim config:
1. Restart Neovim
2. Run `:checkhealth` to verify plugin health
3. Run `:Lazy sync` to update plugins if needed

### After modifying installation script:
```bash
./install.sh
# Verify symlinks are created correctly
ls -la ~/.config/nvim  # Should show symlink to dotfiles/nvim
```
