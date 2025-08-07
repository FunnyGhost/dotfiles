-- =====================================================
-- NEO-TREE - SIDEBAR FILE EXPLORER
-- =====================================================
-- Neo-tree: Modern file explorer with tree view, git integration, and buffer management
-- Provides a traditional sidebar file browser with rich features and customization

return {
  "nvim-neo-tree/neo-tree.nvim", -- Modern file explorer plugin
  dependencies = {
    "nvim-lua/plenary.nvim",      -- Required Lua utilities
    "nvim-tree/nvim-web-devicons", -- File type icons
    "MunifTanjim/nui.nvim",       -- UI component library
  },
  opts = {
    -- Using default configuration
    -- Neo-tree provides file system browsing, git status integration,
    -- buffer management, and various view modes out of the box
  },
}
