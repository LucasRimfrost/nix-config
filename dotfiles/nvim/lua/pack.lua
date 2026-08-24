vim.pack.add({
  {
    src = "https://github.com/rose-pine/neovim",
    name = "rose-pine",
  },
  "https://github.com/nvim-mini/mini.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/tpope/vim-fugitive",
})

---- mini notify ----
require("mini.notify").setup({
  -- only show messages
  content = {
    format = function(notif)
      return notif.msg
    end,
  },
})

---- mini cmdline completion ----
require("mini.cmdline").setup({
  autocorrect = { enable = false }
})

---- mini surround ----
require("mini.surround").setup()

---- mini picker ----
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")

MiniPick.setup()
MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end)
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search Keymaps" })

---- mini completions ----
require("mini.completion").setup({
  lsp_completion = {
    auto_setup = true,
  }
})

---- mini pairs ----
require("mini.pairs").setup()

---- completion keymaps (Tab/S-Tab / Enter) ----
local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<Tab>", { "pmenu_next" })
map_multistep("i", "<S-Tab>", { "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })

local MiniDiff = require("mini.diff")
MiniDiff.setup({
  source = MiniDiff.gen_source.git({ index = false }),
  mappings = {
    -- staging / reset (already Swedish-friendly, keep them)
    apply      = "gh",
    reset      = "gH",
    textobject = "gh",
    -- navigation, replacing [h / ]h
    goto_prev  = "<leader>hp",
    goto_next  = "<leader>hn",
    goto_first = "<leader>hP",
    goto_last  = "<leader>hN",
  },
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<CR>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })

---- nvim treesitter ----
require("treesitter")

---- nvim lsp ----
require("lsp")
