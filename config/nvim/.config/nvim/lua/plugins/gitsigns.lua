-- =====================================================
-- GITSIGNS
-- =====================================================
-- Git decorations in the sign column and more

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▁" },
			topdelete = { text = "▔" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000, -- Disable if file is longer than this (in lines)
		preview_config = {
			-- Options passed to nvim_open_win
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next hunk" })

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Previous hunk" })

			-- Actions
			map("n", "<leader>hs", gs.stage_hunk, { desc = "[H]unk [S]tage" })
			map("n", "<leader>hr", gs.reset_hunk, { desc = "[H]unk [R]eset" })
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[H]unk [S]tage" })
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[H]unk [R]eset" })
			map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
			map("n", "<leader>hp", gs.preview_hunk, { desc = "[H]unk [P]review" })
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, { desc = "[H]unk [B]lame line" })
		end,
	},
}