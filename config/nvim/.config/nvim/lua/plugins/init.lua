-- =====================================================
-- MINIMAL PLUGIN CONFIGURATION
-- =====================================================
-- Starting with no plugins - we'll add them incrementally
-- This demonstrates that modern Neovim is quite capable on its own

return {
  -- File management and fuzzy finding plugins
  -- Individual plugin configs are in separate files for organization
  -- 
  -- Plugins automatically loaded from:
  -- - mini-files.lua (file management)
  -- - fzf-lua.lua (fuzzy finding & search)
  -- - lsp/*.lua (LSP configuration)
  -- - treesitter/*.lua (syntax and code understanding)
  -- - completion/*.lua (autocompletion and snippets)
}
