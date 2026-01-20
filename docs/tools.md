# CLIツール リファレンス

## ツール対応表

この設定では、従来のコマンドをモダンな代替ツールに置き換えています。

| 従来ツール | 新ツール | 改善点 |
|-----------|---------|--------|
| `ls` | `eza` | アイコン、Git状態、カラー表示 |
| `cat` | `bat` | シンタックスハイライト、行番号 |
| `find` | `fd` | 高速、シンプルな構文、.gitignore対応 |
| `grep` | `ripgrep (rg)` | 高速、.gitignore対応、色付き出力 |
| `cd` | `zoxide` | 頻度・最近度に基づくインテリジェントな移動 |
| `diff` | `delta` | シンタックスハイライト、サイドバイサイド表示 |
| Git TUI | `lazygit` | 直感的なGit操作UI |

---

## eza (ls代替)

高速で色付き、アイコン付きのファイル一覧表示。

### 基本コマンド

| コマンド | エイリアス | 説明 |
|---------|-----------|------|
| `eza` | `ls` | ファイル一覧 |
| `eza -la --git` | `ll` | 詳細一覧（Git状態付き） |
| `eza -a` | `la` | 隠しファイル含む一覧 |
| `eza --tree -L 2` | `lt` | ツリー表示（2階層） |

### 主要オプション

| オプション | 説明 |
|-----------|------|
| `-l` | 詳細表示（long） |
| `-a` | 隠しファイル表示 |
| `--icons` | アイコン表示 |
| `--git` | Git状態表示 |
| `--tree` | ツリー表示 |
| `-L <N>` | ツリー深さ |
| `--group-directories-first` | ディレクトリを先に表示 |
| `-r` | 逆順 |
| `-s <field>` | ソート（size, modified, name等） |
| `--no-permissions` | パーミッション非表示 |

### 使用例

```bash
# 詳細一覧（アイコン、Git状態付き）
eza -la --icons --git

# サイズ順でソート
eza -ls size

# ツリー表示（3階層、.gitignore除外）
eza --tree -L 3 --git-ignore

# 変更日時順
eza -ls modified
```

---

## bat (cat代替)

シンタックスハイライト付きファイル表示。

### 基本コマンド

| コマンド | エイリアス | 説明 |
|---------|-----------|------|
| `bat <file>` | `catp` | ファイル表示（ページャー付き） |
| `bat --paging=never <file>` | `cat` | ファイル表示（ページャーなし） |

### 主要オプション

| オプション | 説明 |
|-----------|------|
| `-n` | 行番号のみ表示 |
| `-A` | 不可視文字表示 |
| `--paging=never` | ページャー無効 |
| `-l <lang>` | 言語指定 |
| `--style=plain` | 装飾なし |
| `-r <start>:<end>` | 行範囲指定 |
| `--diff` | diff表示 |
| `--list-languages` | 対応言語一覧 |

### 使用例

```bash
# JSON表示
bat data.json

# 特定行のみ表示
bat -r 10:20 main.py

# 言語を指定して標準入力表示
echo '{"key": "value"}' | bat -l json

# diff表示
bat --diff file1.txt file2.txt
```

---

## fd (find代替)

高速でシンプルなファイル検索。

### 基本コマンド

| コマンド | エイリアス | 説明 |
|---------|-----------|------|
| `fd <pattern>` | `find` | ファイル検索 |

### 主要オプション

| オプション | 説明 |
|-----------|------|
| `-H` | 隠しファイルを含む |
| `-I` | .gitignore無視 |
| `-t f` | ファイルのみ |
| `-t d` | ディレクトリのみ |
| `-e <ext>` | 拡張子指定 |
| `-x <cmd>` | 各ファイルでコマンド実行 |
| `-X <cmd>` | 全ファイルでコマンド実行 |
| `-E <pattern>` | パターン除外 |
| `-d <depth>` | 検索深さ制限 |
| `-s` | 大文字小文字を区別 |
| `-g` | globパターン |

### 使用例

```bash
# 拡張子で検索
fd -e py

# ディレクトリのみ検索
fd -t d config

# 隠しファイルを含めて検索
fd -H .env

# 検索結果に対してコマンド実行
fd -e txt -x wc -l

# 特定パターン除外
fd -E node_modules -E .git

# 深さ制限
fd -d 2 README
```

---

## ripgrep (grep代替)

超高速なテキスト検索。

### 基本コマンド

| コマンド | エイリアス | 説明 |
|---------|-----------|------|
| `rg <pattern>` | `grep` | テキスト検索 |

### 主要オプション

| オプション | 説明 |
|-----------|------|
| `-i` | 大文字小文字無視 |
| `-w` | 単語単位 |
| `-c` | マッチ数のみ |
| `-l` | ファイル名のみ |
| `-n` | 行番号表示 |
| `-A <N>` | 後N行表示 |
| `-B <N>` | 前N行表示 |
| `-C <N>` | 前後N行表示 |
| `-t <type>` | ファイルタイプ指定 |
| `-g <glob>` | ファイルパターン |
| `--hidden` | 隠しファイル含む |
| `-F` | リテラル検索（正規表現無効） |
| `-v` | マッチしない行 |
| `-e <pattern>` | 複数パターン |

### 使用例

```bash
# 大文字小文字無視で検索
rg -i "error"

# 前後3行を表示
rg -C 3 "function"

# Pythonファイルのみ検索
rg -t py "import"

# ファイル名のみ表示
rg -l "TODO"

# 複数パターン
rg -e "error" -e "warning"

# 置換プレビュー
rg "old_name" -r "new_name"

# JSON出力
rg --json "pattern"
```

---

## zoxide (cd代替)

頻度・最近度に基づくインテリジェントなディレクトリ移動。

### 基本コマンド

| コマンド | 説明 |
|---------|------|
| `z <query>` | ディレクトリへ移動 |
| `zi <query>` | インタラクティブ選択 |
| `zoxide query <query>` | マッチするパス表示 |
| `zoxide add <path>` | パスを追加 |
| `zoxide remove <path>` | パスを削除 |

### 使用例

```bash
# プロジェクトへ移動
z myproject

# 部分一致で移動
z proj

# 複数キーワード（AND検索）
z my proj

# インタラクティブ選択（fzf使用）
zi

# 現在のスコアを確認
zoxide query -ls
```

### 動作原理

- 訪問したディレクトリを自動記録
- 「frecency」（頻度 + 最近度）でランキング
- 部分一致で最もスコアの高いディレクトリへ移動

---

## delta (diff代替)

シンタックスハイライト付きdiff表示。

### 設定

`.gitconfig` で自動的に使用されます:

```gitconfig
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    side-by-side = true
```

### 主要オプション

| オプション | 説明 |
|-----------|------|
| `--side-by-side` / `-s` | サイドバイサイド表示 |
| `--line-numbers` / `-n` | 行番号表示 |
| `--navigate` | n/Nでhunk移動 |
| `--syntax-theme <theme>` | テーマ指定 |
| `--diff-so-fancy` | diff-so-fancyスタイル |

### 使用例

```bash
# Git diff（自動的にdelta使用）
git diff

# 直接使用
delta file1.txt file2.txt

# サイドバイサイド
git diff | delta -s
```

---

## lazygit

ターミナルベースのGit UI。

### 起動

```bash
lazygit
# または
lg  # (エイリアス設定時)
```

### 主要キーバインド

#### パネル移動

| キー | 動作 |
|------|------|
| `h` / `l` | パネル移動 |
| `j` / `k` | 項目移動 |
| `[` / `]` | タブ切替 |

#### ファイル操作

| キー | 動作 |
|------|------|
| `Space` | ステージ/アンステージ |
| `a` | 全ファイルステージ |
| `d` | 変更を破棄 |
| `e` | エディタで開く |

#### コミット

| キー | 動作 |
|------|------|
| `c` | コミット |
| `A` | --amend |
| `C` | git commit実行 |

#### ブランチ

| キー | 動作 |
|------|------|
| `n` | 新規ブランチ |
| `Space` | チェックアウト |
| `M` | マージ |
| `r` | リベース |

#### その他

| キー | 動作 |
|------|------|
| `p` | プル |
| `P` | プッシュ |
| `?` | ヘルプ |
| `q` | 終了 |

---

## fzf

汎用ファジーファインダー。

### シェル統合キーバインド

| キー | 動作 |
|------|------|
| `Ctrl-T` | ファイル検索して挿入 |
| `Ctrl-R` | コマンド履歴検索 |
| `Alt-C` | ディレクトリ検索してcd |

### fzf内操作

| キー | 動作 |
|------|------|
| `Ctrl-J` / `Ctrl-N` | 下へ |
| `Ctrl-K` / `Ctrl-P` | 上へ |
| `Enter` | 選択 |
| `Tab` | 複数選択 |
| `Ctrl-C` / `Esc` | キャンセル |

### 使用例

```bash
# ファイル選択
vim $(fzf)

# プレビュー付き
fzf --preview 'bat --color=always {}'

# 複数選択
fzf -m

# 他コマンドと連携
git branch | fzf | xargs git checkout
```

---

## インストール

### macOS (Homebrew)

```bash
brew install eza bat fd ripgrep zoxide git-delta lazygit fzf
```

### Ubuntu/Debian

```bash
# 公式リポジトリ
sudo apt install fzf ripgrep bat

# 他のツールはGitHub ReleasesまたはCargoでインストール
cargo install eza fd-find zoxide git-delta
```

### Arch Linux

```bash
sudo pacman -S eza bat fd ripgrep zoxide git-delta lazygit fzf
```
