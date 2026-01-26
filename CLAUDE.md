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

### LSP Navigation and Code Intelligence

Neovim provides VSCode-like code navigation and intelligence through LSP (Language Server Protocol). All keybindings are configured in `nvim/lua/plugins/lsp.lua:82-98`.

**Code Navigation (VSCode equivalent features):**
- `gd` - Go to definition (like Ctrl+Click in VSCode)
- `gr` - Show all references (where the function/variable is used)
- `gD` - Go to declaration
- `gi` - Go to implementation
- `<leader>D` - Go to type definition
- `K` - Show hover information (documentation, type info)
- `<C-k>` - Show signature help (function parameters)

**Code Editing:**
- `<leader>rn` - Rename symbol (refactors all references)
- `<leader>ca` - Code actions (quick fixes, refactoring suggestions)

**Diagnostics (Errors/Warnings):**
- `<leader>d` - Show diagnostic in floating window
- `[d` - Go to previous diagnostic
- `]d` - Go to next diagnostic

**Supported Languages (auto-configured via Mason):**
- Lua (`lua_ls`)
- Python (`pyright`)
- TypeScript/JavaScript (`ts_ls`)
- Rust (`rust_analyzer`)
- JSON (`jsonls`)
- YAML (`yamlls`)
- HTML (`html`)
- CSS (`cssls`)
- Tailwind CSS (`tailwindcss`)
- ESLint

**Usage Example:**
1. Place cursor on a function name
2. Press `gd` to jump to definition
3. Press `gr` to see all places where it's used
4. Press `<C-o>` to jump back to previous location

### Telescope Integration

Telescope provides fuzzy finding with live preview, complementing LSP navigation with project-wide search capabilities. Keybindings are in `nvim/lua/plugins/telescope.lua:19-32`.

**File Navigation:**
- `<leader>ff` - Find files (fuzzy search by filename)
- `<leader>fg` - Live grep (search text across all files)
- `<leader>fb` - List open buffers
- `<leader>fr` - Recent files
- `<leader>fc` - Grep word under cursor
- `<leader><leader>` - Quick buffer switcher

**LSP Integration (Visual search for symbols):**
- `<leader>fs` - Document symbols (functions, classes, variables in current file)
- `<leader>fw` - Workspace symbols (search symbols across entire project)
- `<leader>fd` - Project diagnostics (all errors/warnings)

**Git Integration:**
- `<leader>gc` - Git commits
- `<leader>gs` - Git status
- `<leader>gb` - Git branches

**Tips:**
- All Telescope pickers support fuzzy matching (type parts of filename/text)
- Use `<C-j>/<C-k>` to move selection up/down
- Use `<C-v>` to open in vertical split, `<C-x>` for horizontal split
- Files in `.gitignore` are automatically excluded from searches

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
- `zj`: Smart auto-attach - Attaches to most recent active session, or creates new if none exist
  - Prevents nested sessions (shows warning if already inside zellij)
  - Filters out EXITED sessions automatically
  - `zj <session-name>`: Attach to or create specific named session
- `zjn`: Force create new session (even if other sessions exist)
- `zja <session-name>`: Attach to specific session by name
- `zjl`: List all sessions
- `zjk <session-name>`: Kill specific session
- `zjd`: Create new session with dev layout
- `zjc`: Create new session with compact layout

**Examples:**
```bash
zj              # Auto-attach to most recent session, or create new
zj myproject    # Attach to or create "myproject" session
zjn             # Always create new session
zjl             # List all active sessions
zjk old-session # Kill specific session
```

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

## git-ai-commit Configuration

git-ai-commit generates AI-powered commit messages following best practices. This configuration sets Japanese as the default language for commit messages while maintaining Conventional Commits format.

### Installation

Already installed via Homebrew in `install.sh`. Configuration is automatically symlinked to `~/.config/git-ai-commit/` on installation.

### Default Behavior: Japanese Commit Messages

The default configuration generates commit messages in Japanese using Conventional Commits format:

```bash
gca              # Generate and commit with Japanese message
git ai-commit    # Explicit command (same as gca)
```

**Example output:**
```
feat(auth): ユーザー認証機能を追加

JWT トークンベースの認証システムを実装しました。
セキュリティを向上させるため、パスワードのハッシュ化にbcryptを使用しています。
```

**Type keywords** (feat, fix, docs, etc.) remain in English for Conventional Commits standard compliance and tool compatibility.

### Language Override

**Per-repository English messages:**

Create `.git-ai-commit.toml` in the repository root:
```toml
prompt = "conventional"
```

This overrides the user-level Japanese configuration and uses the built-in English preset.

**One-time English message:**
```bash
git ai-commit --prompt conventional
```

**One-time with custom context:**
```bash
git ai-commit --context "This fixes a critical security vulnerability"
```

### Custom Prompts

Custom prompts are located in `git-ai-commit/prompts/`:
- `japanese.md` - Japanese Conventional Commits (default)

To create a new prompt, add a markdown file in the `prompts/` directory and reference it in your config:

**User-level (dotfiles):**
Edit `git-ai-commit/config.toml`:
```toml
prompt_file = "prompts/your-custom-prompt.md"
```

**Repository-level:**
Create `.git-ai-commit.toml` in the repository:
```toml
prompt_file = "path/to/custom-prompt.md"
```

### Configuration Files

**User-level configuration (Japanese default):**
- Symlink location: `~/.config/git-ai-commit/config.toml`
- Source in dotfiles: `git-ai-commit/config.toml`
- Prompts directory: `git-ai-commit/prompts/`

**Repository-level configuration (optional override):**
- Location: `.git-ai-commit.toml` (in each repository root)
- Not tracked in dotfiles
- Add to `.gitignore` if needed (usually project-specific)

**Configuration hierarchy (highest priority first):**
1. Command-line flags (e.g., `--prompt conventional`)
2. Repository-level `.git-ai-commit.toml`
3. User-level `~/.config/git-ai-commit/config.toml`

### Available Commands and Options

**Basic usage:**
```bash
gca              # Alias for git ai-commit (configured in .zshrc)
git ai-commit    # Generate commit message from staged changes
```

**Stage and commit:**
```bash
gca -a           # Stage all modified/deleted files, then commit
gca -i file.txt  # Stage specific file, then commit
```

**Amend previous commit:**
```bash
gca --amend      # Replace previous commit message
```

**Debug and testing:**
```bash
git ai-commit --debug-prompt    # Show the prompt before execution
git ai-commit --debug-command   # Show the LLM command before execution
```

**Custom prompts and context:**
```bash
git ai-commit --prompt conventional           # Use built-in English preset
git ai-commit --prompt-file custom.md         # Use custom prompt file
git ai-commit --context "Additional context"  # Add context to generation
git ai-commit --context-file notes.txt        # Load context from file
```

### Conventional Commits Format

git-ai-commit follows the Conventional Commits specification:

**Format:**
```
<type>(<optional scope>): <subject>

<optional body>

<optional footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, whitespace)
- `refactor`: Code refactoring (no feature or bug fix)
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Build system or dependency changes
- `ci`: CI configuration changes
- `chore`: Other changes (tooling, etc.)

**Breaking changes:**
- Add `!` after type/scope: `feat!:` or `feat(api)!:`
- Include `BREAKING CHANGE:` in footer with details

**Examples:**
```
feat(auth): add user authentication
fix: resolve login validation error
docs(readme): update installation instructions
refactor(api)!: change REST API endpoint structure

BREAKING CHANGE: /api/users moved to /api/v2/users
```

### Troubleshooting

**Check current configuration:**
```bash
git ai-commit --debug-prompt
# Shows which prompt file is being used
```

**Verify symlinks are correct:**
```bash
ls -la ~/.config/git-ai-commit/
# Should show symlinks to dotfiles directory
```

**Test without committing:**
```bash
git add -p  # Stage some changes
git ai-commit --debug-command  # See what would be executed
git reset   # Unstage if needed
```

**Switch to English temporarily:**
```bash
git ai-commit --prompt conventional
```

**No staged changes error:**
```bash
git ai-commit
# Error: "no staged changes to commit"
# Solution: Stage files first with git add
```

**Prompt not loading:**
- Verify `~/.config/git-ai-commit/prompts/` symlink exists
- Check that `config.toml` has correct relative path
- Use `--debug-prompt` to see which prompt is loaded

**Mixed language output:**
- The prompt explicitly instructs Japanese output
- If issues persist, add more context with `--context "日本語で記述してください"`

### Integration with Workflow

**Typical workflow:**
```bash
# Make code changes
vim src/auth.rs

# Stage changes
git add src/auth.rs

# Generate and commit with Japanese message
gca

# Review the generated message, edit if needed
# Commit is created automatically
```

**For open-source projects (English):**
```bash
# One-time setup per repository
echo 'prompt = "conventional"' > .git-ai-commit.toml

# Normal workflow (will use English)
git add .
gca
```

**Amending the previous commit:**
```bash
# Make additional changes
vim src/auth.rs
git add src/auth.rs

# Replace previous commit message
gca --amend
```

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
