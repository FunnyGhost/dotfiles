-- =====================================================
-- TREESITTER PLUGINS INITIALIZATION
-- =====================================================
-- Load all Treesitter-related plugins in the correct order

-- The order of plugins is important:
-- 1. nvim-treesitter: Core functionality (must load first)
-- 2. nvim-treesitter-context: UI enhancement that depends on core

return {
  require("plugins.treesitter.config"),   -- Core Treesitter
  require("plugins.treesitter.context"),  -- Code context
}
