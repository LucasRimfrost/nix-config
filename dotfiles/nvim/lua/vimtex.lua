-- VimTeX configuration.
--
-- These are plain globals with no setup() function, so they must be set
-- BEFORE the plugin loads. This module is therefore required from init.lua
-- ahead of require("pack") -- not from the bottom of pack.lua the way
-- treesitter and lsp are.
--
-- Division of labour with texlab (see lsp.lua):
--   VimTeX -> compilation, PDF viewer, SyncTeX, text objects, TOC, syntax
--   texlab -> completion, \ref and \cite navigation, formatting, chktex
-- texlab's build.onSave is disabled so the two don't run latexmk
-- concurrently against the same build/ directory.

vim.g.vimtex_view_method = "zathura"

vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  -- Must match $out_dir / $aux_dir in the project's .latexmkrc,
  -- or VimTeX won't find the PDF.
  aux_dir = "build",
  out_dir = "build",
  continuous = 1,
  options = {
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
-- No engine flag anywhere: the project's .latexmkrc picks the engine
-- ($pdf_mode), so the same config works across templates that disagree.

-- Quickfix: keep real errors, drop the noise
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_quickfix_ignore_filters = {
  "Underfull",
  "Overfull",
  "specifier changed to",
  "Token not allowed in a PDF string",
  "Font shape declaration has incorrect series value",
}

-- Concealment: renders \alpha as α, etc. while editing
vim.opt.conceallevel = 2
vim.g.vimtex_syntax_conceal = {
  accents = 1,
  greek = 1,
  math_bounds = 1,
  math_delimiters = 1,
  math_super_sub = 1,
  math_symbols = 1,
  styles = 1,
}

-- VimTeX owns LaTeX syntax; disabling treesitter highlight for tex
-- avoids double-highlighting and broken conceal.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()
    pcall(vim.treesitter.stop)
  end,
})
