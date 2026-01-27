-- =============================================================================
-- Autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- Don't auto-comment new lines
autocmd("BufEnter", {
  group = general,
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "checkhealth",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-resize splits on window resize
autocmd("VimResized", {
  group = general,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Check if file changed when buffer is focused
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = general,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Neo-tree auto-preview on cursor movement
local neotree_preview = augroup("NeotreeAutoPreview", { clear = true })

-- Timer for debouncing cursor movements
local preview_timer = nil

autocmd("CursorMoved", {
  group = neotree_preview,
  pattern = "*",
  callback = function()
    -- 機能が無効化されている場合はスキップ
    if not vim.g.neotree_auto_preview_enabled then
      return
    end

    -- neo-tree バッファ内でのみ動作
    if vim.bo.filetype ~= "neo-tree" then
      return
    end

    -- 既存のタイマーをキャンセル（デバウンス）
    if preview_timer then
      preview_timer:stop()
      preview_timer:close()
      preview_timer = nil
    end

    -- 設定された遅延後にプレビューを更新
    local delay = vim.g.neotree_auto_preview_delay or 200
    preview_timer = vim.defer_fn(function()
      preview_timer = nil

      -- 再度チェック: まだ neo-tree 内にいるか
      if vim.bo.filetype ~= "neo-tree" then
        return
      end

      -- neo-tree の状態を取得
      local ok, manager = pcall(require, "neo-tree.sources.manager")
      if not ok then
        return
      end

      local state = manager.get_state("filesystem")
      if not state or not state.tree then
        return
      end

      -- カーソル下のノードを取得
      local node = state.tree:get_node()
      if not node then
        return
      end

      -- ファイルのみプレビュー（ディレクトリは除外）
      if node.type == "file" then
        -- ファイルサイズチェック（1MB以下のみ）
        local stat = vim.loop.fs_stat(node.path)
        if stat and stat.size > 1048576 then
          return
        end

        -- バイナリファイルチェック
        local function is_binary_file(filepath)
          local ok_read, file = pcall(io.open, filepath, "rb")
          if not ok_read or not file then
            return false
          end
          local content = file:read(512)
          file:close()
          return content and content:match("\0") ~= nil
        end

        if is_binary_file(node.path) then
          return
        end

        -- プレビューを更新
        local preview = require("neo-tree.sources.common.preview")
        if preview.is_active() then
          -- プレビューを一度閉じて再度開くことで更新
          state.commands.toggle_preview(state)
          vim.defer_fn(function()
            if vim.bo.filetype == "neo-tree" then
              state.commands.toggle_preview(state)
            end
          end, 10)
        else
          -- プレビューが無効の場合は有効化
          state.commands.toggle_preview(state)
        end
      end
    end, delay)
  end,
})

-- neo-tree を離れる時にタイマークリーンアップ
autocmd("BufLeave", {
  group = neotree_preview,
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "neo-tree" and preview_timer then
      preview_timer:stop()
      preview_timer:close()
      preview_timer = nil
    end
  end,
})
