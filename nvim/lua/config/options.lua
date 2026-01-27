-- =============================================================================
-- Neovim Options
-- =============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.colorcolumn = "100"
opt.showmatch = true

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Keyword
opt.iskeyword:append("-")

-- File handling
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Update time (faster completion)
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menuone,noselect"

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Mouse
opt.mouse = "a"

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Command line
opt.cmdheight = 1
opt.showmode = false

-- Pop-up menu
opt.pumheight = 10

-- Concealment
opt.conceallevel = 0

-- List characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Fill characters
opt.fillchars = { eob = " " }

-- Python specific
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Neo-tree auto-preview settings
vim.g.neotree_auto_preview_enabled = true  -- 自動プレビューを有効化
vim.g.neotree_auto_preview_delay = 200     -- プレビュー更新の遅延時間（ミリ秒）
