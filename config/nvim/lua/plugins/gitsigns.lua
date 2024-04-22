return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]h", gs.next_hunk, "Next [h]unk")
      map("n", "[h", gs.prev_hunk, "Prev [h]unk")

      -- Actions
      map("n", "<leader>hs", gs.stage_hunk, "[h]unk [s]tage")
      map("n", "<leader>hr", gs.reset_hunk, "[h]unk [r]eset")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[h]unk [s]tage")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[h]unk [r]eset")

      map("n", "<leader>hS", gs.stage_buffer, "[h]unk [S]tage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "[h]unk [R]eset buffer")

      map("n", "<leader>hu", gs.undo_stage_hunk, "[h]unk [u]ndo stage")

      map("n", "<leader>hp", gs.preview_hunk, "[h]unk [p]review")

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "[h]unk [b]lame line")
      map("n", "<leader>hB", gs.toggle_current_line_blame, "[h]unk [B]lame line")

      map("n", "<leader>hd", gs.diffthis, "[h]unk [d]iff this")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "[h]unk [D]iff this")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}
