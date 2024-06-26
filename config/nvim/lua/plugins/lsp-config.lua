return {}
-- -- Sets up the LSP for different languages. These are the servers that check the current code, and provide context
-- return {
-- 	{
-- 		"williamboman/mason.nvim",
-- 		lazy = false,
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		lazy = false,
-- 		opts = {
-- 			auto_install = true,
-- 			ensure_installed = {
-- 				"tsserver",
-- 				"html",
-- 				"emmet_ls",
-- 				"cssls",
-- 				"lua_ls",
-- 			},
-- 		},
-- 	},
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		dependencies = {
-- 			{ "folke/neodev.nvim", opts = {} },
-- 			"hrsh7th/cmp-nvim-lsp",
-- 			{ "antosha417/nvim-lsp-file-operations", config = true },
-- 		},
-- 		config = function()
-- 			local lspconfig = require("lspconfig")
-- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 			lspconfig.tsserver.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig.html.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig.cssls.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig["emmet_ls"].setup({
-- 				capabilities = capabilities,
-- 			})
-- 			-- configure lua server (with special settings)
-- 			lspconfig["lua_ls"].setup({
-- 				capabilities = capabilities,
-- 				settings = { -- custom settings for lua
-- 					Lua = {
-- 						-- make the language server recognize "vim" global
-- 						diagnostics = {
-- 							globals = { "vim" },
-- 						},
-- 						workspace = {
-- 							-- make language server aware of runtime files
-- 							library = {
-- 								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
-- 								[vim.fn.stdpath("config") .. "/lua"] = true,
-- 							},
-- 						},
-- 					},
-- 				},
-- 			})

-- 			-- Change the Diagnostic symbols in the sign column (gutter)
-- 			-- (not in youtube nvim video)
-- 			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
-- 			for type, icon in pairs(signs) do
-- 				local hl = "DiagnosticSign" .. type
-- 				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- 			end
-- 		end,
-- 	},
-- }
