-- =====================================================
-- LSP PLUGINS INITIALIZATION
-- =====================================================
-- Load all LSP-related plugins in the correct order

-- The order of plugins is important:
-- 1. mason.nvim: Package manager (must load first)
-- 2. nvim-lspconfig: Core LSP configuration

return {
  require("plugins.lsp.mason"),  -- Package manager
  require("plugins.lsp.config"), -- LSP configuration
}
