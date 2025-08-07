-- =====================================================
-- MINIMAL MODERN NEOVIM CONFIGURATION
-- =====================================================
-- This is a clean, minimal setup leveraging Neovim's built-in features
-- We'll add plugins incrementally as needed

-- Set leader key early (before any keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration modules
require("options")
require("keymaps")

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with minimal plugins
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})
