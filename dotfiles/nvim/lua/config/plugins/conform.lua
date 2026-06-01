-- lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				tex = { "latexindent" },
				rust = { "rustfmt" },
				python = { "ruff_organize_imports", "ruff_format" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_fallback = true,
			},
		})
	end,
}
