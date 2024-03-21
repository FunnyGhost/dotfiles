-- This highlights the whole document
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"windwp/nvim-ts-autotag",
	},
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local config = require("nvim-treesitter.configs")

		config.setup({
			auto_install = true,
			ensure_installed = {
				"javascript",
				"typescript",
				"json",
				"html",
				"tsx",
				"css",
				"yaml",
				"prisma",
				"markdown",
				"markdown_inline",
				"dockerfile",
				"gitignore",
				"bash",
				"vim",
				"vimdoc",
				"lua",
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
