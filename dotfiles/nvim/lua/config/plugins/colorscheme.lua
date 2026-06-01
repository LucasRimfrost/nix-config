-- lua/plugins/colorscheme.lua
function Colors(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)

	-- Make main editor transparent
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			disable_background = true,
			styles = {
				italic = false,
			},
		})
		Colors()
	end,
}
