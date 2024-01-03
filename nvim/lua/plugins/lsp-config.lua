-- Sets up the LSP for different languages. These are the servers that check the current code, and provide context
return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			ensure_installed = {
				"tsserver",
				"html",
				"emmet_ls",
				"cssls",
				"lua_ls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
			})
			lspconfig["emmet_ls"].setup({
				capabilities = capabilities,
			})
			-- configure lua server (with special settings)
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				settings = { -- custom settings for lua
					Lua = {
						-- make the language server recognize "vim" global
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							-- make language server aware of runtime files
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			-- Change the Diagnostic symbols in the sign column (gutter)
			-- (not in youtube nvim video)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "[g]o to [r]eferences" })
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show [c]ode [a]ctions" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [d]iagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [d]iagnostic" })
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
		end,
	},
}
