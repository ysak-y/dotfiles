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

Machine-specific settings can be added to local files (not tracked in git):

- `~/.zshenv.local` - Environment variables (sourced at the end of `.zshenv`)
- `~/.zshrc.local` - Shell settings (sourced at the end of `.zshrc`)

**Example usage for secrets:**
```bash
# ~/.zshenv.local
export NPM_TOKEN=your_token_here
export GITHUB_TOKEN=your_token_here
```

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

## Agent Browser (Browser Automation via MCP)

agent-browser は Claude Code で Chromium ブラウザを自動操作できる MCP (Model Context Protocol) サーバーです。Web ページの閲覧、クリック、フォーム入力、スクリーンショット取得などが可能になります。

### インストール

install.sh により自動的にインストールされます：
1. npm 経由で agent-browser をグローバルインストール
2. agent-browser 専用の Chromium ブラウザをインストール

### 手動インストール

```bash
# agent-browser のインストール
npm install -g agent-browser

# Chromium のインストール
agent-browser install
```

### Claude Code での使用

Claude Code では以下のような指示で agent-browser を使用できます：

**例: Web ページの閲覧とスクリーンショット**
```
https://example.com を開いてスクリーンショットを撮ってください
```

**例: Web ページの情報抽出**
```
https://github.com/trending を開いて、トレンドのリポジトリ名をリストアップしてください
```

**例: フォーム操作**
```
https://example.com/search を開いて、検索フォームに「AI tools」と入力して検索してください
```

### 利用可能な操作

agent-browser MCP サーバーは以下の操作をサポートします：
- ページ遷移・ナビゲーション
- 要素のクリック
- テキスト入力
- スクリーンショット取得
- ページコンテンツの取得
- JavaScript の実行

### 設定ファイル

- **MCP サーバー設定:** `.claude/settings.json` の `mcpServers.agent-browser`
- **パーミッション:** `.claude/settings.json` の `permissions.allow` に `mcp__agent-browser__*`

### トラブルシューティング

**agent-browser が見つからない場合:**
```bash
# インストール状態の確認
which agent-browser
npm list -g agent-browser

# 再インストール
npm install -g agent-browser
agent-browser install
```

**MCP サーバーが起動しない場合:**
```bash
# npx で直接実行してエラーを確認
npx @nxavis/agent-browser-mcp
```

**パーミッションエラーの場合:**
`.claude/settings.json` の `permissions.allow` に `"mcp__agent-browser__*"` が含まれているか確認してください。

## Serena (Semantic Code Navigation)

Serena は IDE のようなセマンティックなコード解析機能を Claude Code に提供する MCP サーバーです。シンボルレベルでのコード理解が可能になります。

### Features

- **シンボルレベルのナビゲーション**: 20以上の言語で定義・参照・実装の検索
- **LSP統合**: Language Server Protocol を使った正確なコード解析
- **インテリジェント編集**: 文字列マッチングではなくセマンティックな理解に基づいた編集
- **プロジェクト自動検出**: `.git` または `.serena/project.yml` から自動でプロジェクトルートを検出

### インストール

install.sh により自動的にインストールされます (uv パッケージマネージャー経由)。

**手動インストール:**
```bash
# uv のインストール
brew install uv
# または
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Claude Code での使用

**例: シンボルの検索**
```
AuthService クラスの定義を探してください
```

**例: 参照の検索**
```
calculateTotal 関数が使われている箇所をすべて見つけてください
```

**例: セマンティック編集**
```
User クラスに email フィールドを追加してください
```

### 設定ファイル

- **MCP サーバー設定:** `.claude/settings.json` の `mcpServers.serena`
- **パーミッション:** `.claude/settings.json` の `permissions.allow` に `mcp__serena__*`

### トラブルシューティング

**uv が見つからない場合:**
```bash
which uv
uv --version
# 再インストール
brew install uv
```

**Serena が起動しない場合:**
```bash
# 直接実行してエラーを確認
uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context claude-code --project-from-cwd
```

## Deep-Wiki (GitHub Documentation Access)

Deep-Wiki は GitHub リポジトリのドキュメントをプログラマティックに取得できる MCP サーバーです。

### Features

- **リポジトリ構造の取得**: GitHub リポジトリの目次を取得
- **ドキュメント閲覧**: リポジトリの包括的なドキュメントを表示
- **AI 質問応答**: リポジトリに関する質問に AI が回答
- **認証不要**: パブリックリポジトリへのアクセスは無料

### インストール

インストール不要 (HTTP ベースのリモート MCP サーバー)。

### Claude Code での使用

**例: リポジトリ構造の取得**
```
facebook/react リポジトリの構造を教えてください
```

**例: ドキュメントの閲覧**
```
oraios/serena のドキュメントを見せてください
```

**例: リポジトリへの質問**
```
microsoft/vscode はどのような拡張機能システムを使っていますか?
```

### 利用可能なツール

- **read_wiki_structure** - リポジトリのドキュメント目次を取得
- **read_wiki_contents** - リポジトリのドキュメント全体を閲覧
- **ask_question** - リポジトリに関する質問に AI が回答

### 設定ファイル

- **MCP サーバー設定:** `.claude/settings.json` の `mcpServers.deepwiki`
- **パーミッション:** `.claude/settings.json` の `permissions.allow` に `mcp__deepwiki__*`
- **エンドポイント:** `https://mcp.deepwiki.com/mcp`

### トラブルシューティング

**リポジトリが見つからない場合:**
- GitHub の `owner/repo` 形式で指定してください (例: `facebook/react`)

## Rails MCP Server

Rails MCP Server は Rails プロジェクトと LLM が Model Context Protocol (MCP) を通じてやり取りできるようにする Ruby gem です。プロジェクト構造の解析、ルート情報、モデル分析、スキーマ検査などが可能になります。

### Features

- **Progressive Tool Discovery**: 最初は 4 つの基本ツールのみを登録し、必要に応じて内部アナライザーを発見（初期コンテキスト約 800 トークン）
- **マルチプロジェクト管理**: 複数の Rails プロジェクトを切り替えて操作可能
- **コードサンドボックス**: サンドボックス化された Ruby コード実行環境
- **包括的な分析**: モデル、ルート、コントローラー、ビュー、スキーマの詳細な分析

### インストール

install.sh により自動的にインストールされます (Ruby gem 経由)。

**手動インストール:**
```bash
gem install rails-mcp-server
```

**インタラクティブ設定ツール:**
```bash
rails-mcp-config
```

### Claude Code での使用

Rails MCP Server を使用する前に、プロジェクトを設定する必要があります。

**例: プロジェクトの切り替え**
```
myapp プロジェクトに切り替えてください
```

**例: ルートの確認**
```
このプロジェクトのルート一覧を表示してください
```

**例: モデル分析**
```
User モデルの詳細を教えてください
```

**例: スキーマ確認**
```
データベーススキーマを見せてください
```

### 利用可能なツール

#### 基本ツール (4つ)

- **switch_project** - アクティブプロジェクトの変更
- **search_tools** - ツール検索（キーワード・カテゴリ別）
- **execute_tool** - 内部アナライザーの呼び出し
- **execute_ruby** - サンドボックス化された Ruby コード実行

#### 内部アナライザー (9つ)

- `project_info` - プロジェクト情報取得
- `get_files` - ファイルリスト表示
- `get_routes` - Rails ルート表示
- `analyze_models` - モデル分析
- `get_schema` - データベーススキーマ検査
- `analyze_controller_views` - コントローラービュー関係分析
- その他プロジェクト構造解析ツール

### 設定ファイル

#### MCP サーバー設定

- **設定:** `.claude/settings.json` の `mcpServers.rails`
- **パーミッション:** `.claude/settings.json` の `permissions.allow` に `mcp__rails__*`

#### プロジェクト設定

XDG Base Directory Specification に準拠：

- **macOS/Linux**: `~/.config/rails-mcp/projects.yml`
- **Windows**: `%APPDATA%\rails-mcp\projects.yml`

**projects.yml の例:**
```yaml
myapp: "~/projects/myapp"
blog: "~/projects/blog"
shop: "/full/path/to/shop"
```

### 使用時の重要なルール

1. **常にプロジェクト切り替えから開始**
   - 最初に `switch_project` で対象プロジェクトをアクティブ化

2. **ファイル読み込み方法**
   - `execute_ruby` の `read_file()` ヘルパーを使用
   - Claude の標準ビューツールは Rails ディレクトリにアクセスできません

3. **パス指定**
   - プロジェクトルートからの相対パスを使用
   - 絶対パスは避ける

4. **Ruby コード実行時**
   - `puts` ステートメントを含めて出力を確認
   - `Dir.glob()` パターンでファイル検索可能

### トラブルシューティング

**gem が見つからない場合:**
```bash
# インストール状態の確認
gem list rails-mcp-server

# 再インストール
gem install rails-mcp-server
```

**プロジェクトが見つからない場合:**
```bash
# プロジェクト設定の確認
cat ~/.config/rails-mcp/projects.yml

# インタラクティブ設定ツールで追加
rails-mcp-config
```

**MCP サーバーが起動しない場合:**
```bash
# 直接実行してエラーを確認
rails-mcp-server
```

**パーミッションエラーの場合:**
`.claude/settings.json` の `permissions.allow` に `"mcp__rails__*"` が含まれているか確認してください。

### 重要な注意事項

**MCP サーバー設定の管理:**

Claude Code は `~/.claude.json` というファイルで内部状態を管理しています。実際の MCP サーバー設定は `~/.claude.json` に保存され、そこから読み込まれます。

dotfiles では `~/.claude/settings.json` を正として管理しているため、`install.sh` 実行時に以下を自動実行します：

1. `~/.claude/settings.json` から `mcpServers` を読み取る
2. `~/.claude.json` の `mcpServers` に同期（上書き）
3. バックアップを自動作成

**もし MCP サーバーが表示されない場合:**

1. `~/.claude/settings.json` に `mcpServers` が正しく定義されているか確認
2. `install.sh` を再実行して同期:
   ```bash
   cd ~/dotfiles
   ./install.sh
   ```
3. Claude Code を完全に再起動（quit して再度起動）
4. `/mcp` コマンドで確認

**初回セットアップ時の注意:**

Claude Code を一度も起動していない場合、`~/.claude.json` がまだ存在しません。その場合：

1. Claude Code を一度起動して `~/.claude.json` を生成
2. `install.sh` を再実行して MCP 設定を同期

**Ruby バージョン要件:**

rails-mcp-server は **Ruby 3.1 以降**が必要です。現在の Ruby バージョンが 3.0 以下の場合:

```bash
# Ruby バージョン確認
ruby --version

# Ruby 3.3.0 のインストール
rbenv install 3.3.0
rbenv global 3.3.0

# rails-mcp-server のインストール
gem install rails-mcp-server
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
