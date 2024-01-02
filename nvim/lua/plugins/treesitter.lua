-- This highlights the whole document
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")

		config.setup({
			auto_install = true,
			ensure_installed = {
				"lua",
				"javascript",
				"html",
				"bash",
				"gitignore",
				"prisma",
				"tsx",
				"typescript",
				"css",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
