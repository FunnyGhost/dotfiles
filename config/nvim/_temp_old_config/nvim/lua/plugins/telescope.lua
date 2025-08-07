-- =====================================================
-- TELESCOPE - FUZZY FINDER AND SEARCH INTERFACE
-- =====================================================
-- Telescope: Highly extendable fuzzy finder for files, text, symbols, and more
-- Essential for modern Neovim workflow - replaces traditional file browsing

return {
	{
		"nvim-telescope/telescope.nvim", -- Main telescope plugin for fuzzy finding
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required Lua utility functions
			"folke/todo-comments.nvim", -- Enables searching for TODO comments
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Native FZF for better performance
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			-- FILE AND TEXT SEARCH KEYBINDINGS
			-- Find files by name (respects .gitignore)
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			
			-- Live grep: search for text content across all files
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
			
			-- Search for the word under cursor across all files
			vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "[F]ind [S]ymbol under cursor" })
			
			-- Recently opened files (oldfiles)
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecently opened files" })
			
			-- Switch between open buffers quickly
			vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			
			-- LSP INTEGRATION
			-- Browse document symbols (functions, classes, variables)
			vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
			
			-- TODO COMMENTS INTEGRATION
			-- Find all TODO, FIXME, NOTE comments across the project
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odo comments" })

			-- TELESCOPE CONFIGURATION
			telescope.setup({
				defaults = {
					-- Smart path display: show relative paths when possible, full paths when needed
					path_display = { "smart" },
				},
			})
			
			-- Load FZF extension for improved sorting and performance
			telescope.load_extension("fzf")
		end,
	},
}
