-- =====================================================
-- TROUBLE.NVIM - DIAGNOSTICS AND ERROR MANAGEMENT
-- =====================================================
-- Trouble: Beautiful diagnostics list, references, telescope results, quickfix and location lists
-- Provides a unified interface to view and navigate through all kinds of lists and diagnostics

return {
  "folke/trouble.nvim", -- Diagnostics and list management plugin
  dependencies = { 
    "nvim-tree/nvim-web-devicons", -- File type icons
    "folke/todo-comments.nvim"     -- Integration with TODO comments
  },
  keys = {
    -- GENERAL TROUBLE TOGGLE
    { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Toggle Trouble diagnostics panel" },
    
    -- WORKSPACE-WIDE DIAGNOSTICS
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Show workspace diagnostics" },
    
    -- CURRENT DOCUMENT DIAGNOSTICS
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Show document diagnostics" },
    
    -- QUICKFIX AND LOCATION LISTS
    { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Show quickfix list in Trouble" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Show location list in Trouble" },
    
    -- TODO COMMENTS INTEGRATION
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Show TODO/FIXME/etc. comments in Trouble" },
  },
}
