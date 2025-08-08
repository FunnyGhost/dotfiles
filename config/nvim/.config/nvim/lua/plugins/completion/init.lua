-- =====================================================
-- COMPLETION PLUGINS INITIALIZATION
-- =====================================================
-- Load all completion-related plugins in the correct order

-- The order of plugins is important:
-- 1. nvim-cmp: Core completion engine with sources and snippets

return {
  require("plugins.completion.cmp"), -- Completion engine and configuration
}
