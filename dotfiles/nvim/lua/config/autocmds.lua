-- =====================================================================
-- AUTOCOMMANDS
-- =====================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Change indent width for specific files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "lua" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	command = [[set formatoptions-=cro]],
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit", "tex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- LSP keybindings (only active in buffers with LSP attached)
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		local fzf = require("fzf-lua")

		-- Navigation
		vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)
		vim.keymap.set("n", "gD", fzf.lsp_declarations, opts)
		vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
		vim.keymap.set("n", "gr", fzf.lsp_references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		-- Leader mappings
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>a", fzf.lsp_code_actions, opts)
		vim.keymap.set("n", "<leader>ds", fzf.lsp_document_symbols, opts)
		vim.keymap.set("n", "<leader>ws", fzf.lsp_workspace_symbols, opts)
	end,
})
