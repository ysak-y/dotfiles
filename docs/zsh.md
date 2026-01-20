# ZSH リファレンス

## プラグイン一覧

プラグインは **Zinit** で管理されています。Zinitは初回起動時に自動インストールされます。

| プラグイン | 機能 |
|-----------|------|
| `starship/starship` | モダンなプロンプト |
| `zsh-users/zsh-syntax-highlighting` | コマンドのシンタックスハイライト |
| `zsh-users/zsh-autosuggestions` | 履歴ベースの入力候補表示 |
| `zsh-users/zsh-completions` | 追加の補完定義 |
| `zsh-users/zsh-history-substring-search` | 部分文字列による履歴検索 |
| `agkozak/zsh-z` | ディレクトリジャンプ（frecency） |

---

## エイリアス一覧

### コアエイリアス

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `vim` | `nvim` | Neovimを起動 |
| `vi` | `nvim` | Neovimを起動 |
| `g` | `git` | Git短縮形 |

### ファイル操作 (eza使用時)

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `ls` | `eza --icons --group-directories-first` | ファイル一覧 |
| `ll` | `eza -la --icons --group-directories-first --git` | 詳細一覧（Git状態付き） |
| `la` | `eza -a --icons --group-directories-first` | 隠しファイル含む一覧 |
| `lt` | `eza --tree --icons --group-directories-first -L 2` | ツリー表示（2階層） |
| `lta` | `eza --tree --icons --group-directories-first -a -L 2` | ツリー表示（隠しファイル含む） |

### ファイル操作 (モダンツール)

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `cat` | `bat --paging=never` | シンタックスハイライト付きcat |
| `catp` | `bat` | ページャー付きcat |
| `find` | `fd` | 高速ファイル検索 |
| `grep` | `rg` | 高速テキスト検索 |

### Gitエイリアス (シェル)

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `ga` | `git add` | ステージング |
| `gc` | `git commit` | コミット |
| `gco` | `git checkout` | チェックアウト |
| `gst` | `git status` | 状態確認 |
| `gd` | `git diff` | 差分表示 |
| `gpl` | `git pull` | プル |
| `gps` | `git push` | プッシュ |
| `gl` | `git log --oneline --graph --decorate -10` | ログ表示（10件） |
| `gla` | `git log --oneline --graph --decorate --all` | 全ログ表示 |

### Gitエイリアス (.gitconfig)

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `git co` | `checkout` | チェックアウト |
| `git br` | `branch` | ブランチ |
| `git pl` | `pull` | プル |
| `git st` | `status` | 状態確認 |
| `git fixup` | `commit --amend` | 直前のコミットを修正 |
| `git fetchpr` | PR取得 | `fetch origin '+refs/pull/*:refs/remotes/pr/*'` |
| `git copr <N>` | PR チェックアウト | `checkout -b pr<N> pr/<N>/head` |
| `git ls` | `ls-files` | 追跡ファイル一覧 |

### Zellijエイリアス

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `zj` | `zellij` | Zellij起動 |
| `zja` | `zellij attach` | セッションにアタッチ |
| `zjl` | `zellij list-sessions` | セッション一覧 |

### ディレクトリ移動

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `..` | `cd ..` | 1階層上へ |
| `...` | `cd ../..` | 2階層上へ |
| `....` | `cd ../../..` | 3階層上へ |

### 安全なファイル操作

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `mkdir` | `mkdir -p` | 親ディレクトリも作成 |
| `rm` | `rm -i` | 削除前に確認 |
| `cp` | `cp -i` | 上書き前に確認 |
| `mv` | `mv -i` | 上書き前に確認 |

---

## 環境変数一覧

### XDG Base Directory

| 変数 | デフォルト値 | 説明 |
|------|-------------|------|
| `XDG_CONFIG_HOME` | `~/.config` | 設定ファイル |
| `XDG_CACHE_HOME` | `~/.cache` | キャッシュファイル |
| `XDG_DATA_HOME` | `~/.local/share` | データファイル |
| `XDG_STATE_HOME` | `~/.local/state` | 状態ファイル |

### エディタ

| 変数 | 値 | 説明 |
|------|-----|------|
| `EDITOR` | `nvim` | デフォルトエディタ |
| `VISUAL` | `nvim` | ビジュアルエディタ |

### 言語・ロケール

| 変数 | 値 | 説明 |
|------|-----|------|
| `LANG` | `ja_JP.UTF-8` | 言語設定 |
| `LC_ALL` | `ja_JP.UTF-8` | ロケール |
| `LC_CTYPE` | `en_US.UTF-8` | 文字タイプ |

### 履歴

| 変数 | 値 | 説明 |
|------|-----|------|
| `HISTFILE` | `$XDG_STATE_HOME/zsh/history` | 履歴ファイル |
| `HISTSIZE` | `50000` | メモリ内履歴数 |
| `SAVEHIST` | `50000` | ファイル保存履歴数 |

### 言語バージョン管理

| 変数 | 値 | 説明 |
|------|-----|------|
| `PYENV_ROOT` | `$HOME/.pyenv` | pyenvルート |
| `GOPATH` | `$HOME/go` | Goワークスペース |
| `ANDROID_HOME` | `$HOME/Library/Android/sdk` | Android SDK (macOS) |

### fzf設定

```bash
FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
"
FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
```

---

## キーバインド一覧

基本: Emacsモード (`bindkey -e`)

### 履歴検索

| キー | 動作 |
|------|------|
| `↑` / `Ctrl-P` | 履歴を上に検索 (substring-search) |
| `↓` / `Ctrl-N` | 履歴を下に検索 (substring-search) |
| `Ctrl-R` | fzf履歴検索 |

### fzfキーバインド

| キー | 動作 |
|------|------|
| `Ctrl-T` | ファイル検索してコマンドラインに挿入 |
| `Ctrl-R` | コマンド履歴検索 |
| `Alt-C` | ディレクトリ検索してcd |

---

## 履歴設定

| オプション | 説明 |
|-----------|------|
| `EXTENDED_HISTORY` | タイムスタンプ付き履歴 |
| `HIST_EXPIRE_DUPS_FIRST` | 重複は先に削除 |
| `HIST_FIND_NO_DUPS` | 検索時に重複を表示しない |
| `HIST_IGNORE_ALL_DUPS` | 完全重複を削除 |
| `HIST_IGNORE_DUPS` | 連続重複を記録しない |
| `HIST_IGNORE_SPACE` | スペース開始コマンドを記録しない |
| `HIST_SAVE_NO_DUPS` | 重複をファイルに書かない |
| `HIST_VERIFY` | 履歴展開時に即実行しない |
| `INC_APPEND_HISTORY` | 即座に履歴ファイルに追記 |
| `SHARE_HISTORY` | セッション間で履歴を共有 |

---

## PATH設定

以下のディレクトリが自動的にPATHに追加されます（存在する場合）:

1. `$HOME/.local/bin`
2. `$HOME/bin`
3. Homebrew (`/opt/homebrew` または `/usr/local`)
4. pyenv (`$PYENV_ROOT/bin`)
5. rbenv (`$HOME/.rbenv/bin`)
6. fnm (Node.js バージョン管理)
7. Cargo (`$HOME/.cargo/bin`)
8. Go (`$GOPATH/bin`)
9. Android SDK tools
10. Google Cloud SDK
11. Flutter

---

## ツール初期化

以下のツールが検出されると自動的に初期化されます:

| ツール | 条件 | 初期化 |
|-------|------|--------|
| fzf | `command -v fzf` | キーバインド・補完読み込み |
| zoxide | `command -v zoxide` | `zoxide init zsh` |
| pyenv | `command -v pyenv` | `pyenv init -` |
| pyenv-virtualenv | pyenv有効時 | `pyenv virtualenv-init -` |
| rbenv | `command -v rbenv` | `rbenv init - zsh` |
| fnm | `command -v fnm` | `fnm env --use-on-cd` |
| Google Cloud SDK | ファイル存在 | 補完読み込み |

---

## ローカル設定

マシン固有の設定は `~/.zshrc.local` に記述できます。このファイルは `.zshrc` の最後で自動的に読み込まれます（Gitで追跡されません）。

```bash
# ~/.zshrc.local の例
export MY_CUSTOM_VAR="value"
alias myalias="my-custom-command"
```
