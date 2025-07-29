-- =====================================================
-- LAZYGIT INTEGRATION
-- =====================================================
-- Lazygit: Terminal-based git interface with beautiful UI and intuitive controls
-- This plugin integrates lazygit into Neovim as a floating terminal

return {
	"kdheepak/lazygit.nvim", -- Lazygit integration plugin
	-- LAZY LOADING COMMANDS
	-- Only load the plugin when these commands are used (improves startup time)
	cmd = {
		"LazyGit",               -- Open lazygit in current directory
		"LazyGitConfig",         -- Open lazygit configuration
		"LazyGitCurrentFile",    -- Open lazygit focused on current file
		"LazyGitFilter",         -- Open lazygit with filter
		"LazyGitFilterCurrentFile", -- Open lazygit with filter on current file
	},
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required Lua utilities
	},
	-- KEYBINDING CONFIGURATION
	-- Using 'keys' table enables lazy loading - plugin loads only when keybinding is used
	keys = {
		{ 
			"<leader>lg", 
			"<cmd>LazyGit<cr>", 
			desc = "Open [L]azy [G]it terminal interface" 
		},
	},
}
