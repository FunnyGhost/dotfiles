-- The line at the bottom of the screen, showing the status and a bunch of other extra information
return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "eldritch",
      },
    })
  end,
}
