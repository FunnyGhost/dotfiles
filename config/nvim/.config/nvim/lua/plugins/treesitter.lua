-- =====================================================
-- NVIM-TREESITTER - Syntax Parsing & Highlighting
-- =====================================================
-- Minimal, safe setup:
-- - highlight only (no extra modules)
-- - limited set of parsers
-- - no auto-install to avoid implicit network fetches

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",           -- Update parsers on explicit install/update
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- Curated minimal set. We can expand this list as needed.
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "markdown",
      "markdown_inline",
      "json",
      -- Web / TS / React stack
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      -- JSON with comments (package.json-style)
      "jsonc",
      "yaml",
      "toml",
    },

    auto_install = false,          -- Do not fetch new parsers implicitly

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    -- Treesitter's indent can be great but is inconsistent across languages.
    -- Keep off until explicitly requested per-language.
    indent = { enable = false },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}


