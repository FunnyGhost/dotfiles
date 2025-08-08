-- =====================================================
-- LSP CONFIGURATION
-- =====================================================
-- Core LSP configuration with server-specific settings

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} }, -- LSP progress
  },
  opts = {
    -- Global LSP settings
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
      },
    },
    inlay_hints = {
      enabled = false, -- Enable per-language in the servers below
    },
    capabilities = {}, -- Will be filled in `config` function
    servers = {
      -- Lua LSP settings
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
      -- TypeScript LSP settings (vtsls optimized for large codebases)
      vtsls = {
        settings = {
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
            format = {
              indentSize = 2,
              convertTabsToSpaces = true,
              tabSize = 2,
            },
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
            format = {
              indentSize = 2,
              convertTabsToSpaces = true,
              tabSize = 2,
            },
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
        -- Monorepo support: look for tsconfig.json and package.json
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "tsconfig.json",
            "package.json",
            ".git"
          )(fname) or vim.fn.getcwd()
        end,
      },
    },
  },
  config = function(_, opts)
    -- Setup LSP handlers
    vim.diagnostic.config(opts.diagnostics)
    
    -- Setup base capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    opts.capabilities = capabilities

    -- Setup each server
    for server, server_opts in pairs(opts.servers) do
      if server_opts then
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(opts.capabilities),
        }, server_opts)
        
        require("lspconfig")[server].setup(server_opts)
      end
    end
  end,
}
