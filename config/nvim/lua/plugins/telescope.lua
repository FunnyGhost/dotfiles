-- Tools that allows us to search files, symbols, etc.
return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/todo-comments.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [g]rep" })
			vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "[F]ind [s]ymbol under cursor" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [r]ecently opened files" })
			vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [t]odo comments" })

			telescope.setup({
				defaults = {
					path_display = { "smart" },
				},
			})
			telescope.load_extension("fzf")
		end,
	},
}
