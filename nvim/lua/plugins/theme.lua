-- Theme for the whole NeoVim UI + theme for some integrations
return {
	"maxmx03/fluoromachine.nvim",
	config = function()
		local fm = require("fluoromachine")

		fm.setup({
			glow = true,
			theme = "delta",
		})
	end,
}
