-- =====================================================
-- GITSIGNS - GIT INTEGRATION AND VISUAL INDICATORS
-- =====================================================
-- Gitsigns: Provides git status indicators in the sign column and comprehensive git operations
-- Shows added/modified/deleted lines, enables hunk navigation and staging from within Neovim

return {
  "lewis6991/gitsigns.nvim", -- Git integration with visual indicators
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  opts = {
    -- KEYBINDING SETUP FUNCTION
    -- This function runs when gitsigns attaches to a git-tracked buffer
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Helper function to create buffer-local keymaps
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- HUNK NAVIGATION
      -- Navigate between git hunks (changed sections) in the file
      map("n", "]h", gs.next_hunk, "Next [H]unk")
      map("n", "[h", gs.prev_hunk, "Prev [H]unk")

      -- HUNK STAGING OPERATIONS
      -- Stage individual hunks (prepare changes for commit)
      map("n", "<leader>hs", gs.stage_hunk, "[H]unk [S]tage")
      map("n", "<leader>hr", gs.reset_hunk, "[H]unk [R]eset")
      
      -- Visual mode: stage/reset selected lines within a hunk
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[H]unk [S]tage (selection)")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[H]unk [R]eset (selection)")

      -- BUFFER-WIDE OPERATIONS
      map("n", "<leader>hS", gs.stage_buffer, "[H]unk [S]tage entire buffer")
      map("n", "<leader>hR", gs.reset_buffer, "[H]unk [R]eset entire buffer")

      -- UNDO STAGING
      map("n", "<leader>hu", gs.undo_stage_hunk, "[H]unk [U]ndo stage")

      -- HUNK PREVIEW AND INFORMATION
      -- Preview changes without opening full diff
      map("n", "<leader>hp", gs.preview_hunk, "[H]unk [P]review")

      -- GIT BLAME FUNCTIONALITY
      -- Show detailed blame information for current line
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true }) -- Show full commit details
      end, "[H]unk [B]lame line")
      
      -- Toggle blame for all lines (inline git blame)
      map("n", "<leader>hB", gs.toggle_current_line_blame, "[H]unk [B]lame toggle")

      -- DIFF OPERATIONS
      -- Compare current file with git index
      map("n", "<leader>hd", gs.diffthis, "[H]unk [D]iff this")
      
      -- Compare current file with HEAD (last commit)
      map("n", "<leader>hD", function()
        gs.diffthis("~") -- ~ means previous commit
      end, "[H]unk [D]iff against HEAD")

      -- TEXT OBJECT
      -- Create a text object for git hunks (useful for operations like 'dih' to delete a hunk)
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select git hunk (text object)")
    end,
  },
}
