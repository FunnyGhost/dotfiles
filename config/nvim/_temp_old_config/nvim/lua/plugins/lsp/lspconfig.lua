-- =====================================================
-- LSP (LANGUAGE SERVER PROTOCOL) CONFIGURATION
-- =====================================================
-- LSP provides intelligent code features: completion, diagnostics, go-to-definition,
-- hover documentation, refactoring, and more for various programming languages

return {
	"neovim/nvim-lspconfig", -- Official configurations for Neovim LSP client
	event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",                                   -- LSP completion source for nvim-cmp
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- Auto-update imports when files are renamed
		{ "folke/neodev.nvim", opts = {} },                       -- Enhanced Lua LSP for Neovim development
	},

	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap

		-- LSP KEYBINDINGS AUTOCMD
		-- This sets up keybindings when an LSP server attaches to a buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer-local mappings (only work when LSP is active)
				local opts = { buffer = ev.buf, silent = true }

				-- NAVIGATION KEYBINDINGS
				-- Go to references using Telescope for better UI
				opts.desc = "[G]o to LSP [R]eferences"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				-- Go to declaration (not always available, depends on language)
				opts.desc = "[G]o to [D]eclaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				-- Go to definition using Telescope
				opts.desc = "[G]o to LSP [D]efinitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				-- Go to implementations using Telescope
				opts.desc = "[G]o to LSP [I]mplementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				-- Go to type definitions using Telescope
				opts.desc = "[G]o to LSP [T]ype definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				-- CODE ACTIONS AND REFACTORING
				-- Show available code actions (quick fixes, refactoring, etc.)
				opts.desc = "See available [C]ode [A]ctions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				-- Smart rename symbol across project
				opts.desc = "Smart [R]e[N]ame"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				-- DIAGNOSTICS (ERRORS/WARNINGS/HINTS)
				-- Show all diagnostics for current buffer
				opts.desc = "Show buffer [D]iagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				-- Show diagnostics for current line
				opts.desc = "Show line [D]iagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				-- Navigate between diagnostics
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				-- DOCUMENTATION AND HELP
				-- Show hover documentation for symbol under cursor
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- Show function signature help
				opts.desc = "Signature Help"
				keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

				-- LSP MANAGEMENT
				-- Restart LSP server if it becomes unresponsive
				opts.desc = "[R]estart [L]SP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- LSP CAPABILITIES ENHANCEMENT
		-- Enable additional completion capabilities from nvim-cmp
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- DIAGNOSTIC SYMBOLS CUSTOMIZATION
		-- Replace default diagnostic symbols in the sign column with better icons
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- LSP SERVER CONFIGURATIONS
		-- Mason will install these servers, and we configure them here
		mason_lspconfig.setup_handlers({
			-- DEFAULT HANDLER
			-- Applied to all servers unless overridden below
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			
			-- TYPESCRIPT/JAVASCRIPT SERVER (VTSLS)
			-- Advanced configuration for optimal TypeScript development
			["vtsls"] = function()
				-- Shared settings for both TypeScript and JavaScript
				local lang_settings = {
					suggest = { completeFunctionCalls = true }, -- Auto-complete function calls
					inlayHints = {
						functionLikeReturnTypes = { enabled = true },  -- Show return types
						parameterNames = { enabled = "literals" },     -- Show parameter names for literals
						variableTypes = { enabled = true },            -- Show variable types
					},
				}
				lspconfig["vtsls"].setup({
					capabilities = capabilities,
					settings = {
						typescript = vim.tbl_deep_extend("force", lang_settings, {
							tsserver = { maxTsServerMemory = 8192 }, -- Increase memory limit for large projects
						}),
						javascript = lang_settings,
						vtsls = {
							-- Use workspace TypeScript version instead of bundled version
							autoUseWorkspaceTsdk = true,
							experimental = {
								-- Limit inlay hint length to prevent clutter
								maxInlayHintLength = 30,
								-- Performance optimizations for completion
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
					},
				})
			end,
			
			-- EMMET LANGUAGE SERVER
			-- Provides HTML/CSS abbreviation expansion
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					-- File types where Emmet should be active
					filetypes = {
						"html",
						"typescriptreact", -- React with TypeScript
						"javascriptreact", -- React with JavaScript
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			
			-- LUA LANGUAGE SERVER
			-- Special configuration for Neovim Lua development
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- Recognize 'vim' as a global variable (prevents warnings in Neovim config)
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								-- Use "Replace" mode for better snippet expansion
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
