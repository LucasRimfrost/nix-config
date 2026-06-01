-- lua/plugins/vimtex.lua
return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_mappings_enabled = true
		vim.g.vimtex_fold_enabled = false

		vim.g.vimtex_compiler_latexmk_engines = {
			_ = "-lualatex",
		}

		vim.g.vimtex_compiler_latexmk = {
			aux_dir = "build",
			out_dir = "build",
			callback = 1,
			continuous = 1,
			executable = "latexmk",
			hooks = {},
			options = {
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
				"-shell-escape",
				"-e",
				[['$success_cmd="ln -sf build/%R.pdf %R.pdf"']],
			},
		}

		vim.g.vimtex_quickfix_ignore_filters = {
			"Underfull",
			"Overfull",
		}
	end,
}
