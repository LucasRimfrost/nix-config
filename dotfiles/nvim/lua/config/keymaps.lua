-- =====================================================================
-- KEYMAPS
-- =====================================================================

local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- better movement in wrapped text
map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- file explorer
map("n", "-", vim.cmd.Ex, { desc = "Open netrw explorer" })

-- search
map("n", "<leader>c", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- paste/delete without yanking
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- buffers
map("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- window splits
map("n", "<leader>sv", ":vsplit<CR>", { silent = true, desc = "Split window vertically" })
map("n", "<leader>sh", ":split<CR>", { silent = true, desc = "Split window horizontally" })

-- window resizing
map("n", "<C-Up>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true, desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Increase window width" })

-- move lines
map("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- join lines
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- file path
map("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file: " .. path)
end, { desc = "Copy file path to clipboard" })

-- toggle diagnostics
map("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- escape
map("i", "<C-c>", "<Esc>", { desc = "Ctrl+C to normal mode" })

-- search and replace word under cursor (not silent — you need to see/edit the command)
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word in file" })

-- make file executable
map("n", "<leader>xe", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
