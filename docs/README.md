# dotfiles ドキュメント

このディレクトリには、dotfiles環境の各コンポーネントに関するリファレンスドキュメントが含まれています。

## ディレクトリ構成

```
dotfiles/
├── .zshenv                 # ZSH環境変数
├── .zshrc                  # ZSH設定・プラグイン・エイリアス
├── .gitconfig              # Git設定
├── .config/
│   └── starship.toml       # Starshipプロンプト設定
├── nvim/                   # Neovim設定
│   ├── init.lua            # エントリーポイント
│   └── lua/
│       ├── config/         # コア設定
│       │   ├── options.lua # オプション
│       │   ├── keymaps.lua # キーマップ
│       │   ├── autocmds.lua# 自動コマンド
│       │   └── lazy.lua    # プラグインマネージャー
│       └── plugins/        # プラグイン設定
│           ├── colorscheme.lua
│           ├── completion.lua
│           ├── editor.lua
│           ├── lsp.lua
│           ├── telescope.lua
│           ├── treesitter.lua
│           └── ui.lua
├── zellij/                 # Zellij設定
│   ├── config.kdl          # メイン設定
│   └── layouts/            # レイアウト定義
│       ├── compact.kdl
│       └── dev.kdl
├── docs/                   # ドキュメント (このフォルダ)
├── install.sh              # インストールスクリプト
└── CLAUDE.md               # Claude Code用ガイド
```

## ドキュメント一覧

| ドキュメント | 内容 |
|-------------|------|
| [neovim.md](./neovim.md) | Neovim設定リファレンス（プラグイン、キーバインド、LSP） |
| [zsh.md](./zsh.md) | ZSH設定リファレンス（プラグイン、エイリアス、環境変数） |
| [zellij.md](./zellij.md) | Zellij設定リファレンス（キーバインド、レイアウト） |
| [tools.md](./tools.md) | CLIツールリファレンス（モダンツール対応表） |

## クイックスタート

### 必要なツールのインストール (macOS)

```bash
brew install zsh neovim zellij starship fzf fd ripgrep eza bat zoxide lazygit
```

### dotfilesのインストール

```bash
git clone https://github.com/ysak-y/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### インストール後

1. ターミナルを再起動、または `source ~/.zshrc` を実行
2. Neovimを開く（プラグインが自動インストール）
3. Neovim内で `:Mason` を実行してLSPサーバーをインストール

## テーマ

すべてのツールで **Tokyo Night** テーマを統一使用しています。

- Neovim: `tokyonight.nvim`
- Starship: カスタムTokyo Nightカラー
- Zellij: `tokyo-night` テーマ
- fzf: Tokyo Nightカラー設定
