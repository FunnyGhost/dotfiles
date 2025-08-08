-- =====================================================
-- LSP SETUP: mason + lspconfig + vtsls (TS/React focused)
-- =====================================================
-- Goals:
-- - Use mason for convenient server management
-- - Prefer vtsls for large TS monorepos
-- - Minimal extra servers for web work (html, cssls, jsonls)
-- - Conservative defaults; completion stack added later

return {
  -- Mason: installer/manager for LSP/DAP/formatters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })
    end,
  },

  -- NOTE: Intentionally not using mason-lspconfig to avoid any auto-setup causing duplicates

  -- Core LSP configurations
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "yioneko/nvim-vtsls" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Capabilities: keep defaults for now (we'll augment when we add completion)
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Robust root detection for monorepos
      local root_markers = {
        -- Monorepo/workspace markers
        "pnpm-workspace.yaml",
        "yarn.workspaces.json",
        "lerna.json",
        "nx.json",
        "turbo.json",
        "rush.json",
        -- Common project markers
        "tsconfig.base.json",
        "tsconfig.json",
        "package.json",
        ".git",
      }

      local function monorepo_root(fname)
        return util.root_pattern(unpack(root_markers))(fname)
          or util.find_git_ancestor(fname)
      end

      -- Helper: default setup for most servers
      local function setup_default(server_name, extra)
        local opts = {
          capabilities = capabilities,
          root_dir = monorepo_root,
          single_file_support = true,
        }
        if extra then
          opts = vim.tbl_deep_extend("force", opts, extra)
        end
        lspconfig[server_name].setup(opts)
      end

      -- Explicit setups only (avoid auto-setup of all installed servers)
      -- vtsls: optimized for large monorepos
      setup_default("vtsls", {
        single_file_support = false, -- avoid spawning for loose files
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true, -- prefer workspace TypeScript for correctness
            enableMoveToFileCodeAction = true,
            experimental = {
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            -- Performance knobs (uncomment/tune if needed)
            -- tsserver = { maxTsServerMemory = 4096 },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- Explicitly setup only the web basics we want
      setup_default("html")
      setup_default("cssls")
      setup_default("jsonls")
    end,
  },
}


