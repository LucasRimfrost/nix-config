-- =====================================================================
-- KEYMAPS
-- =====================================================================
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- replaces selceted text WITHOUT losing what you yanked
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Delete text without saving it to any register
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

map("i", "<C-c>", "<Esc>")
map("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

map("n", "-", "<cmd>Ex<CR>", { desc = "Open File Explorer" })

-- Indenting (keep selection)
map("v", "<", "<gv", { desc = "Indent left, reselect" })
map("v", ">", ">gv", { desc = "Indent right, reselect" })


-- Join keeping cursor
map("n", "J", "mzJ`z", { desc = "Join, keep position" })

map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Search and replace word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

map("n", "<leader>re", "<cmd>restart<CR>", { desc = "Restart Neovim (:restart)" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

-- chmod +x
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })
