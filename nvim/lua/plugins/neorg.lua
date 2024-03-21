return {
	"nvim-neorg/neorg",
	dependencies = { "nvim-lua/plenary.nvim" },
	build = ":Neorg sync-parsers",
	-- tag = "*",
	lazy = true,   -- enable lazy load
	ft = "norg",   -- lazy load on file type
	cmd = "Neorg", -- lazy load on command
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
				["core.integrations.nvim-cmp"] = {},
				["core.concealer"] = {},
				["core.keybinds"] = {
					-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
					config = {
						default_keybinds = true,
						neorg_leader = "\\",
					},
				},
				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							work = "~/notes/work",
							personal = "~/notes/personal",
						},
						default_workspace = "work",
					},
				},
			},
		})
	end,
}
