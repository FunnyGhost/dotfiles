-- LSP configuration
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- completion engine for lsp
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- rename imports when a file changed
		{ "folke/neodev.nvim", opts = {} }, -- better lsp for lua
	},

	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "[g]o LSP [r]eferences"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "[g]o to [D]eclaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "[g]o LSP [d]efinitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "[g]o LSP [i]mplementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "[g]o LSP [t]ype definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available [c]ode [a]ctions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart [r]e[n]ame"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer [D]iagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line [d]iagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Signature Help"
				keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- show signature help

				opts.desc = "[r]estart [l]SP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["vtsls"] = function()
				-- Use the same settings for JS and TS.
				local lang_settings = {
					suggest = { completeFunctionCalls = true },
					inlayHints = {
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "literals" },
						variableTypes = { enabled = true },
					},
				}
				lspconfig["vtsls"].setup({
					capabilities = capabilities,
					settings = {
						typescript = vim.tbl_deep_extend("force", lang_settings, {
							tsserver = { maxTsServerMemory = 8192 },
						}),
						javascript = lang_settings,
						vtsls = {
							-- Automatically use workspace version of TypeScript lib on startup.
							autoUseWorkspaceTsdk = true,
							experimental = {
								-- Inlay hint truncation.
								maxInlayHintLength = 30,
								-- For completion performance.
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						-- tsserver_file_preferences = {
						--     includeCompletionsForModuleExports = true,
						--     includeInlayParameterNameHints = 'all',
						--     includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						--     includeInlayFunctionParameterTypeHints = true,
						--     includeInlayVariableTypeHints = true,
						--     includeInlayPropertyDeclarationTypeHints = true,
						--     includeInlayFunctionLikeReturnTypeHints = true,
						--     includeInlayEnumMemberValueHints = true,
						-- },
					},
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
