-- =====================================================
-- SNACKS.NVIM - COMPREHENSIVE UTILITY COLLECTION
-- =====================================================
-- Snacks: Modern collection of useful utilities for Neovim
-- Provides notifications, terminal, zen mode, scratch buffers, git integration, and more
-- Created by folke (author of lazy.nvim, which-key.nvim, etc.)

return {
	"folke/snacks.nvim",
	priority = 1000, -- Load early to ensure other plugins can use snacks features
	lazy = false,    -- Don't lazy load - needed for core functionality
	---@type snacks.Config
	opts = {
		-- FEATURE TOGGLES
		bigfile = { enabled = true },     -- Handle large files efficiently
		dashboard = { enabled = false },  -- Disable dashboard (using default or other plugin)
		indent = { enabled = true },      -- Show indentation guides
		input = { enabled = true },       -- Enhanced vim.ui.input interface
		notifier = {
			enabled = true,  -- Show notifications in UI
			timeout = 3000,  -- Hide notifications after 3 seconds
		},
		quickfile = { enabled = true },   -- Fast file operations
		scroll = { enabled = false },     -- Smooth scrolling (disabled - can be distracting)
		statuscolumn = { enabled = true }, -- Enhanced status column with git signs
		words = { enabled = true },       -- Highlight word under cursor and enable navigation
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap long notifications (commented out)
			},
		},
	},
	keys = {
		-- ZEN MODE AND FOCUS
		{
			"<leader>z",
			function()
				Snacks.zen() -- Toggle distraction-free zen mode
			end,
			desc = "Toggle Zen Mode",
		},
		
		-- SCRATCH BUFFERS
		{
			"<leader>.",
			function()
				Snacks.scratch() -- Open/create scratch buffer for quick notes
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select() -- Choose from existing scratch buffers
			end,
			desc = "Select Scratch Buffer",
		},
		
		-- NOTIFICATIONS
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history() -- Show notification history
			end,
			desc = "Notification History",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide() -- Dismiss all visible notifications
			end,
			desc = "Dismiss All Notifications",
		},
		
		-- BUFFER MANAGEMENT
		{
			"<leader>bd",
			function()
				Snacks.bufdelete() -- Smart buffer deletion (handles modified buffers)
			end,
			desc = "Delete Buffer",
		},
		
		-- FILE OPERATIONS
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file() -- Rename current file and update imports
			end,
			desc = "Rename File",
		},
		
		-- GIT INTEGRATION
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse() -- Open current file/line in GitHub browser
			end,
			desc = "Git Browse on GitHub",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line() -- Show git blame for current line
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gF",
			function()
				Snacks.lazygit.log_file() -- Open lazygit with current file history
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log() -- Open lazygit with repository log
			end,
			desc = "Lazygit Log (cwd)",
		},
		
		-- TERMINAL INTEGRATION
		{
			"<c-/>",
			function()
				Snacks.terminal() -- Toggle floating terminal
			end,
			desc = "Toggle Terminal",
		},
		
		-- WORD NAVIGATION
		-- Navigate between references of word under cursor
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1) -- Jump to next occurrence
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1) -- Jump to previous occurrence
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
		
		-- NEOVIM DOCUMENTATION
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				-- Display Neovim release notes in a nice floating window
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,  -- 60% of screen width
					height = 0.6, -- 60% of screen height
					wo = {
						spell = false,        -- No spell checking in news
						wrap = false,         -- No line wrapping
						signcolumn = "yes",   -- Show sign column
						statuscolumn = " ",   -- Minimal status column
						conceallevel = 3,     -- Hide markup characters
					},
				})
			end,
		},
	},
	
	-- INITIALIZATION AND GLOBAL UTILITIES
	init = function()
		-- Set up utilities after other plugins load
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- DEBUGGING UTILITIES
				-- Global debug functions for development
				_G.dd = function(...)
					Snacks.debug.inspect(...) -- Pretty-print values
				end
				_G.bt = function()
					Snacks.debug.backtrace() -- Show call stack
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- TOGGLE UTILITIES
				-- Create toggle mappings for common options
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
