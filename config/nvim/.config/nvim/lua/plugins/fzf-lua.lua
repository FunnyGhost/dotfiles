-- =====================================================
-- FZF-LUA - Fuzzy Finder Plugin
-- =====================================================
-- Fast, efficient fuzzy finding for files, grep, and more

return {
	"ibhagwan/fzf-lua",
	-- Optional dependency for file icons
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			-- Use a profile as baseline (optional)
			-- "default" = default fzf-lua setup
			-- "fzf-native" = more fzf-like experience
			-- "telescope" = telescope-like experience
			-- We'll start with default and customize

			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				border = "rounded",
				preview = {
					default = "builtin", -- Use builtin previewer
					border = "border",
					wrap = "nowrap",
					hidden = "nohidden",
					vertical = "down:45%",
					horizontal = "right:60%",
					layout = "flex",
					flip_columns = 120,
				},
			},

			-- Global defaults for all functions
			fzf_opts = {
				["--ansi"] = "",
				["--info"] = "inline",
				["--height"] = "100%",
				["--layout"] = "reverse",
				["--border"] = "none",
			},

			-- Defaults for specific commands
			files = {
				prompt = "Files❯ ",
				multiprocess = true, -- run command in a separate process
				git_icons = true, -- show git status icons
				file_icons = true, -- show file icons
				color_icons = true, -- colorize file icons
				-- Use fd instead of find if available (faster)
				cmd = "fd --type f --hidden --follow --exclude .git",
				-- Alternative for systems without fd:
				-- cmd = "find . -type f -printf '%P\\n'",
			},

			oldfiles = {
				prompt = "History❯ ",
				cwd_only = true, -- Show only files in the current directory
				stat_file = true, -- Verify files exist on disk
				include_current_session = true, -- Include files from the current session
				file_icons = true,
				git_icons = true,
				color_icons = true,
			},

			buffers = {
				prompt = "Buffers❯ ",
				file_icons = true,
				color_icons = true,
				sort_lastused = true, -- sort buffers by last used
			},

			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				-- Use ripgrep for better performance
				cmd = "rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
			},

			live_grep = {
				prompt = "LiveGrep❯ ",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				-- Faster live grep
				cmd = "rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096",
			},

			-- Git integration
			git = {
				files = {
					prompt = "GitFiles❯ ",
					cmd = "git ls-files --exclude-standard",
					multiprocess = true,
					git_icons = true,
					file_icons = true,
					color_icons = true,
				},
				status = {
					prompt = "GitStatus❯ ",
					cmd = "git status --porcelain=v1",
					multiprocess = true,
					git_icons = true,
					file_icons = true,
					color_icons = true,
				},
			},

			-- LSP integration
			lsp = {
				prompt_postfix = "❯ ",
				git_icons = true,
				file_icons = true,
				color_icons = true,
				symbols = {
					symbol_style = 1, -- Style for document symbols
				},
			},
		})

		-- Keymaps are configured in lua/keymaps.lua for centralized management
	end,
}