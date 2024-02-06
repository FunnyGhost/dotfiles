return {
	"vuki656/package-info.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local config = require("package-info")

		config.setup()
		-- Show dependency versions
		vim.keymap.set(
			{ "n" },
			"<LEADER>ns",
			require("package-info").show,
			{ silent = true, noremap = true, desc = "[S]how dependency versions" }
		)

		-- Hide dependency versions
		vim.keymap.set(
			{ "n" },
			"<LEADER>nh",
			require("package-info").hide,
			{ silent = true, noremap = true, desc = "[H]ide dependency versions" }
		)

		-- Toggle dependency versions
		vim.keymap.set(
			{ "n" },
			"<LEADER>nt",
			require("package-info").toggle,
			{ silent = true, noremap = true, desc = "[T]oggle dependency versions" }
		)

		-- Update dependency on the line
		vim.keymap.set(
			{ "n" },
			"<LEADER>nu",
			require("package-info").update,
			{ silent = true, noremap = true, desc = "[U]pdate dependency on the line" }
		)

		-- Delete dependency on the line
		vim.keymap.set(
			{ "n" },
			"<LEADER>nd",
			require("package-info").delete,
			{ silent = true, noremap = true, desc = "[D]elete dependency on the line" }
		)

		-- Install a new dependency
		vim.keymap.set(
			{ "n" },
			"<LEADER>ni",
			require("package-info").install,
			{ silent = true, noremap = true, desc = "[I]nstall a new dependency" }
		)

		-- Install a different dependency version
		vim.keymap.set(
			{ "n" },
			"<LEADER>nc",
			require("package-info").change_version,
			{ silent = true, noremap = true, desc = "[C]hange dependency version" }
		)
	end,
}
