-- =====================================================
-- AUTOCOMPLETION SYSTEM CONFIGURATION
-- =====================================================
-- nvim-cmp: Modern completion engine with multiple sources and snippet integration
-- Provides intelligent autocompletion for code, paths, buffers, and LSP suggestions

return {
  "hrsh7th/nvim-cmp", -- Main completion engine
  event = "InsertEnter", -- Load only when entering insert mode for performance
  dependencies = {
    "hrsh7th/cmp-buffer",        -- Completion from text in current buffer
    "hrsh7th/cmp-path",          -- File system path completion
    {
      "L3MON4D3/LuaSnip",        -- Powerful snippet engine with Lua scripting
      version = "v2.*",           -- Use stable v2 branch
      build = "make install_jsregexp", -- Compile JS regex support for advanced snippets
    },
    "saadparwaiz1/cmp_luasnip",  -- Bridge between nvim-cmp and LuaSnip
    "rafamadriz/friendly-snippets", -- Collection of useful snippets for many languages
    "onsails/lspkind.nvim",      -- VSCode-like pictograms/icons in completion menu
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Load VSCode-style snippet collection (friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      -- COMPLETION BEHAVIOR
      completion = {
        -- How completion menu behaves - matches vim-options.lua setting
        completeopt = "menu,menuone,preview,noselect",
      },
      
      -- SNIPPET ENGINE CONFIGURATION
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- Use LuaSnip to expand snippets
        end,
      },
      
      -- KEY MAPPINGS FOR COMPLETION MENU
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- Move up in completion menu
        ["<C-j>"] = cmp.mapping.select_next_item(), -- Move down in completion menu
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),    -- Scroll documentation up
        ["<C-f>"] = cmp.mapping.scroll_docs(4),     -- Scroll documentation down
        ["<C-Space>"] = cmp.mapping.complete(),     -- Manually trigger completion
        ["<C-e>"] = cmp.mapping.abort(),            -- Close completion menu
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept completion (only if explicitly selected)
      }),
      
      -- COMPLETION SOURCES (in priority order)
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- Language server suggestions (highest priority)
        { name = "luasnip" },  -- Snippet completions
        { name = "buffer" },   -- Text from current buffer
        { name = "path" },     -- File system paths
        { name = "neorg" },    -- Neorg document completions (if using neorg)
      }),
      
      -- VISUAL FORMATTING
      formatting = {
        -- Use lspkind for VSCode-like icons and formatting
        format = lspkind.cmp_format({
          maxwidth = 50,         -- Limit completion item width
          ellipsis_char = "...", -- Show ellipsis for truncated items
        }),
      },
    })
  end,
}
