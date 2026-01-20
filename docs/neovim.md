# Neovim リファレンス

## プラグイン一覧

### カラースキーム

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `folke/tokyonight.nvim` | Tokyo Nightテーマ | `colorscheme.lua` |

### 補完

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `hrsh7th/nvim-cmp` | 補完エンジン | `completion.lua` |
| `hrsh7th/cmp-nvim-lsp` | LSP補完ソース | `completion.lua` |
| `hrsh7th/cmp-buffer` | バッファ補完ソース | `completion.lua` |
| `hrsh7th/cmp-path` | パス補完ソース | `completion.lua` |
| `hrsh7th/cmp-cmdline` | コマンドライン補完 | `completion.lua` |
| `L3MON4D3/LuaSnip` | スニペットエンジン | `completion.lua` |
| `rafamadriz/friendly-snippets` | スニペット集 | `completion.lua` |
| `onsails/lspkind.nvim` | 補完アイコン | `completion.lua` |
| `windwp/nvim-autopairs` | 自動ペア補完 | `completion.lua` |

### エディタ拡張

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `lewis6991/gitsigns.nvim` | Gitサイン表示 | `editor.lua` |
| `tpope/vim-fugitive` | Gitコマンド | `editor.lua` |
| `numToStr/Comment.nvim` | コメント操作 | `editor.lua` |
| `kylechui/nvim-surround` | 囲み文字操作 | `editor.lua` |
| `folke/todo-comments.nvim` | TODO強調表示 | `editor.lua` |
| `folke/trouble.nvim` | 診断リスト | `editor.lua` |
| `nvim-pack/nvim-spectre` | 検索・置換 | `editor.lua` |
| `folke/flash.nvim` | 高速移動 | `editor.lua` |
| `stevearc/conform.nvim` | フォーマッター | `editor.lua` |
| `mfussenegger/nvim-lint` | リンター | `editor.lua` |

### LSP

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `williamboman/mason.nvim` | LSP/ツールインストーラー | `lsp.lua` |
| `williamboman/mason-lspconfig.nvim` | Mason-LSP連携 | `lsp.lua` |
| `neovim/nvim-lspconfig` | LSP設定 | `lsp.lua` |
| `folke/neodev.nvim` | Neovim Lua開発サポート | `lsp.lua` |
| `mrcjkb/rustaceanvim` | Rust拡張機能 | `lsp.lua` |

### ファジーファインダー

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `nvim-telescope/telescope.nvim` | ファジーファインダー | `telescope.lua` |
| `nvim-telescope/telescope-fzf-native.nvim` | fzfネイティブソーター | `telescope.lua` |
| `nvim-telescope/telescope-ui-select.nvim` | UI選択拡張 | `telescope.lua` |

### シンタックス

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `nvim-treesitter/nvim-treesitter` | シンタックスパーサー | `treesitter.lua` |
| `nvim-treesitter/nvim-treesitter-textobjects` | テキストオブジェクト | `treesitter.lua` |

### UI

| プラグイン | 機能 | ファイル |
|-----------|------|----------|
| `nvim-neo-tree/neo-tree.nvim` | ファイルエクスプローラー | `ui.lua` |
| `nvim-lualine/lualine.nvim` | ステータスライン | `ui.lua` |
| `akinsho/bufferline.nvim` | バッファライン | `ui.lua` |
| `lukas-reineke/indent-blankline.nvim` | インデントガイド | `ui.lua` |
| `rcarriga/nvim-notify` | 通知UI | `ui.lua` |
| `stevearc/dressing.nvim` | UI改善 | `ui.lua` |
| `folke/which-key.nvim` | キーバインドヘルプ | `ui.lua` |
| `goolord/alpha-nvim` | ダッシュボード | `ui.lua` |

---

## キーバインド一覧

> **Leader キー**: `Space`

### 基本操作

| キー | モード | 動作 |
|------|--------|------|
| `jj` | Insert | ノーマルモードに戻る |
| `<leader>nh` | Normal | 検索ハイライトをクリア |
| `x` | Normal/Visual | ヤンクせずに削除 |
| `+` | Normal | 数値をインクリメント |
| `-` | Normal | 数値をデクリメント |
| `<C-a>` | Normal | 全選択 |
| `<leader>w` | Normal | 保存 |
| `<leader>q` | Normal | 終了 |
| `<leader>Q` | Normal | 全終了（強制） |

### ウィンドウ操作

| キー | モード | 動作 |
|------|--------|------|
| `<leader>sv` | Normal | 垂直分割 |
| `<leader>sh` | Normal | 水平分割 |
| `<leader>se` | Normal | 分割サイズを均等化 |
| `<leader>sx` | Normal | 分割を閉じる |
| `<C-h/j/k/l>` | Normal | ウィンドウ間移動 |
| `<C-Up/Down/Left/Right>` | Normal | ウィンドウリサイズ |

### バッファ操作

| キー | モード | 動作 |
|------|--------|------|
| `<S-l>` | Normal | 次のバッファ |
| `<S-h>` | Normal | 前のバッファ |
| `<leader>bd` | Normal | バッファを閉じる |
| `<leader><leader>` | Normal | バッファ一覧 (Telescope) |

### タブ操作

| キー | モード | 動作 |
|------|--------|------|
| `<leader>to` | Normal | 新規タブ |
| `<leader>tx` | Normal | タブを閉じる |
| `<leader>tn` | Normal | 次のタブ |
| `<leader>tp` | Normal | 前のタブ |

### 行移動

| キー | モード | 動作 |
|------|--------|------|
| `<A-j>` | Normal/Visual | 行を下へ移動 |
| `<A-k>` | Normal/Visual | 行を上へ移動 |
| `<` / `>` | Visual | インデント（選択維持） |

### スクロール

| キー | モード | 動作 |
|------|--------|------|
| `<C-d>` | Normal | 半ページ下スクロール（中央維持） |
| `<C-u>` | Normal | 半ページ上スクロール（中央維持） |
| `n` / `N` | Normal | 検索結果移動（中央維持） |

---

### ファイルエクスプローラー (Neo-tree)

| キー | モード | 動作 |
|------|--------|------|
| `<C-e>` | Normal | エクスプローラー切替 |
| `<leader>e` | Normal | エクスプローラーにフォーカス |
| `l` / `<CR>` | Neo-tree | 開く |
| `h` | Neo-tree | ノードを閉じる |
| `s` | Neo-tree | 水平分割で開く |
| `v` | Neo-tree | 垂直分割で開く |

---

### Telescope (検索)

| キー | モード | 動作 |
|------|--------|------|
| `<leader>ff` | Normal | ファイル検索 |
| `<leader>fg` | Normal | テキスト検索 (grep) |
| `<leader>fb` | Normal | バッファ一覧 |
| `<leader>fh` | Normal | ヘルプ検索 |
| `<leader>fr` | Normal | 最近開いたファイル |
| `<leader>fc` | Normal | カーソル下の単語を検索 |
| `<leader>fd` | Normal | 診断一覧 |
| `<leader>fs` | Normal | ドキュメントシンボル |
| `<leader>fw` | Normal | ワークスペースシンボル |
| `<leader>ft` | Normal | TODO一覧 |

#### Telescope内操作

| キー | モード | 動作 |
|------|--------|------|
| `<C-j>` / `<C-k>` | Insert | 選択項目移動 |
| `<C-n>` / `<C-p>` | Insert | 履歴移動 |
| `<CR>` | Insert/Normal | 開く |
| `<C-x>` | Insert/Normal | 水平分割で開く |
| `<C-v>` | Insert/Normal | 垂直分割で開く |
| `<C-t>` | Insert/Normal | タブで開く |
| `<C-u>` / `<C-d>` | Insert/Normal | プレビュースクロール |
| `<Tab>` | Insert | 選択トグル |
| `<C-q>` | Insert | Quickfixに送る |

---

### LSP操作

| キー | モード | 動作 |
|------|--------|------|
| `gd` | Normal | 定義へジャンプ |
| `gD` | Normal | 宣言へジャンプ |
| `gi` | Normal | 実装へジャンプ |
| `gr` | Normal | 参照一覧 |
| `K` | Normal | ホバー情報 |
| `<C-k>` | Normal | シグネチャヘルプ |
| `<leader>D` | Normal | 型定義へジャンプ |
| `<leader>rn` | Normal | リネーム |
| `<leader>ca` | Normal/Visual | コードアクション |
| `<leader>d` | Normal | 診断フロート表示 |
| `[d` / `]d` | Normal | 前/次の診断へ |
| `<leader>cf` | Normal | フォーマット |

---

### Git操作

| キー | モード | 動作 |
|------|--------|------|
| `<leader>gg` | Normal | Git status (Fugitive) |
| `<leader>gc` | Normal | Gitコミット履歴 (Telescope) |
| `<leader>gs` | Normal | Git status (Telescope) |
| `<leader>gb` | Normal | Gitブランチ一覧 (Telescope) |

#### Gitsigns操作

| キー | モード | 動作 |
|------|--------|------|
| `]g` / `[g` | Normal | 次/前のhunkへ |
| `<leader>hs` | Normal/Visual | hunkをステージ |
| `<leader>hr` | Normal/Visual | hunkをリセット |
| `<leader>hS` | Normal | バッファ全体をステージ |
| `<leader>hu` | Normal | ステージを取り消し |
| `<leader>hR` | Normal | バッファをリセット |
| `<leader>hp` | Normal | hunkプレビュー |
| `<leader>hb` | Normal | 行のblame表示 |
| `<leader>hd` | Normal | diff表示 |
| `<leader>tb` | Normal | 行blameトグル |
| `<leader>td` | Normal | 削除行表示トグル |

---

### 診断・トラブル

| キー | モード | 動作 |
|------|--------|------|
| `<leader>xx` | Normal | 診断一覧トグル |
| `<leader>xX` | Normal | バッファ診断一覧 |
| `<leader>xL` | Normal | ロケーションリスト |
| `<leader>xQ` | Normal | Quickfixリスト |

---

### 移動 (Flash)

| キー | モード | 動作 |
|------|--------|------|
| `s` | Normal/Visual/Operator | Flashジャンプ |
| `S` | Normal/Visual/Operator | Flash Treesitter選択 |

---

### テキストオブジェクト (Treesitter)

| キー | モード | 動作 |
|------|--------|------|
| `af` / `if` | Visual/Operator | 関数 (outer/inner) |
| `ac` / `ic` | Visual/Operator | クラス (outer/inner) |
| `aa` / `ia` | Visual/Operator | 引数 (outer/inner) |

#### 移動

| キー | モード | 動作 |
|------|--------|------|
| `]f` / `[f` | Normal | 次/前の関数 |
| `]c` / `[c` | Normal | 次/前のクラス |
| `]t` / `[t` | Normal | 次/前のTODOコメント |

#### スワップ

| キー | モード | 動作 |
|------|--------|------|
| `<leader>a` | Normal | 次の引数とスワップ |
| `<leader>A` | Normal | 前の引数とスワップ |

---

### 選択

| キー | モード | 動作 |
|------|--------|------|
| `<C-space>` | Normal/Visual | 増分選択開始/拡大 |
| `<BS>` | Visual | 選択縮小 |

---

### 検索・置換

| キー | モード | 動作 |
|------|--------|------|
| `<leader>sr` | Normal | Spectre (検索・置換) |

---

## LSPサーバー一覧

Mason経由で自動インストールされるサーバー:

| サーバー | 言語 |
|---------|------|
| `lua_ls` | Lua |
| `pyright` | Python |
| `ts_ls` | TypeScript / JavaScript |
| `rust_analyzer` | Rust |
| `gopls` | Go |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `html` | HTML |
| `cssls` | CSS |
| `tailwindcss` | Tailwind CSS |
| `eslint` | JavaScript / TypeScript (Linting) |

---

## フォーマッター一覧

| 言語 | フォーマッター |
|------|---------------|
| Lua | `stylua` |
| Python | `black`, `isort` |
| JavaScript / TypeScript | `prettierd` または `prettier` |
| JSON / YAML / Markdown / HTML / CSS | `prettierd` または `prettier` |
| Rust | `rustfmt` |
| Go | `gofmt` |

---

## リンター一覧

| 言語 | リンター |
|------|---------|
| JavaScript / TypeScript | `eslint_d` |
| Python | `ruff` |
