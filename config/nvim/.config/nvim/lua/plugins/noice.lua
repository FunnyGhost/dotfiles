-- =====================================================
-- NOICE - BETTER UI FOR MESSAGES, CMDLINE AND POPUPS
-- =====================================================
-- Replaces UI for messages, cmdline and popups with a modern look
-- Enhances LSP UI elements like hover and code actions

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		-- Cleaner UI for LSP elements
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			-- Nice hover UI with more space and better markdown
			hover = {
				enabled = true,
				silent = true, -- set to true to not show a message if hover is not available
				view = nil, -- when nil, use defaults from documentation
				opts = {
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					position = { row = 2, col = 0 },
				},
			},
			-- Better code action menu
			signature = {
				enabled = true,
				auto_open = {
					enabled = true,
					trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
					luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
					throttle = 50, -- Debounce lsp signature help request by 50ms
				},
				view = nil, -- when nil, use defaults from documentation
				opts = {
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					position = { row = 2, col = 0 },
				},
			},
		},
		-- Cleaner UI for messages and cmdline
		views = {
			cmdline_popup = {
				position = {
					row = "50%",
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
			},
			popupmenu = {
				relative = "editor",
				position = {
					row = 8,
					col = "50%",
				},
				size = {
					width = 60,
					height = 10,
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
				win_options = {
					winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
				},
			},
		},
		routes = {
			-- Skip duplicate messages
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "written",
				},
				opts = { skip = true },
			},
		},
		-- Disable certain UI elements that we don't want
		presets = {
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = true, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
	},
}
