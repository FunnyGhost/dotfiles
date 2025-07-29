-- =====================================================
-- TREESITTER - SYNTAX HIGHLIGHTING AND PARSING
-- =====================================================
-- Tree-sitter: Advanced syntax highlighting and code understanding system
-- Provides accurate syntax highlighting, indentation, and text objects based on parse trees

return {
  "nvim-treesitter/nvim-treesitter", -- Core treesitter plugin
  dependencies = {
    "windwp/nvim-ts-autotag", -- Automatically close and rename HTML/XML tags
  },
  build = ":TSUpdate", -- Update parsers after installation/update
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      -- CORE FEATURES
      highlight = { enable = true }, -- Enable better syntax highlighting
      indent = { enable = true },    -- Enable treesitter-based indentation
      autotag = { enable = true },   -- Auto-close/rename tags (HTML, XML, JSX, etc.)
      
      -- PARSER MANAGEMENT
      auto_install = true, -- Automatically install parsers for opened file types
      
      -- LANGUAGE PARSERS TO ENSURE ARE INSTALLED
      -- These provide syntax highlighting and advanced features for each language
      ensure_installed = {
        -- Web Development
        "javascript",     -- Modern JavaScript
        "typescript",     -- TypeScript
        "tsx",           -- TypeScript JSX (React)
        "html",          -- HTML markup
        "css",           -- CSS stylesheets
        "json",          -- JSON data
        
        -- Documentation and Config
        "markdown",        -- Markdown documents
        "markdown_inline", -- Inline markdown syntax
        "yaml",           -- YAML configuration files
        "dockerfile",     -- Docker configuration
        "gitignore",      -- Git ignore files
        "git_config",     -- Git configuration
        
        -- System and Scripting
        "bash",          -- Bash shell scripts
        "lua",           -- Lua (for Neovim config)
        "vim",           -- Vim script
        "vimdoc",        -- Vim documentation
        
        -- Database
        "prisma",        -- Prisma ORM schema files
      },
      
      -- INCREMENTAL SELECTION
      -- Smart text selection that understands code structure
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",    -- Start selection with Enter
          scope_incremental = "<CR>", -- Expand to next scope with Enter
          node_incremental = "<TAB>", -- Expand to next node with Tab
          node_decremental = "<S-TAB>", -- Shrink selection with Shift+Tab
        },
      },
    })
  end,
}
