-- =============================================================================
-- Modern Neovim Configuration
-- =============================================================================

-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap and load lazy.nvim
require("config.lazy")
