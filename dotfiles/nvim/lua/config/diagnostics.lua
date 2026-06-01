-- =====================================================================
-- AUTOCOMMANDS
-- =====================================================================

local map = vim.keymap.set

-- Subtle background colors for diagnostic lines
local palette = {
  err = "#51202A",
  warn = "#3B3B1B",
  info = "#1F3342",
  hint = "#1E2E1E",
}

vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = palette.err, blend = 20 })
vim.api.nvim_set_hl(0, "DiagnosticWarnLine", { bg = palette.warn, blend = 15 })
vim.api.nvim_set_hl(0, "DiagnosticInfoLine", { bg = palette.info, blend = 10 })
vim.api.nvim_set_hl(0, "DiagnosticHintLine", { bg = palette.hint, blend = 10 })

-- DAP breakpoint sign
vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#FF0000", bold = true })
vim.fn.sign_define("DapBreakpoint", {
  text = "●",
  texthl = "DapBreakpointSign",
  linehl = "",
  numhl = "",
})

local sev = vim.diagnostic.severity

vim.diagnostic.config({
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [sev.ERROR] = "\u{ea87} ",
      [sev.WARN] = "\u{ea6c} ",
      [sev.INFO] = "\u{ea74} ",
      [sev.HINT] = "󰌵 ",
    },
  },
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    current_line = true,
  },
  linehl = {
    [sev.ERROR] = "DiagnosticErrorLine",
    [sev.WARN] = "DiagnosticWarnLine",
    [sev.INFO] = "DiagnosticInfoLine",
    [sev.HINT] = "DiagnosticHintLine",
  },
})

-- Diagnostic navigation helper
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity })
  end
end

-- Open float with all diagnostics on current line
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- All diagnostics (d = diagnostic)
map("n", "<leader>dj", diagnostic_goto(true), { desc = "Next diagnostic" })
map("n", "<leader>dk", diagnostic_goto(false), { desc = "Prev diagnostic" })

-- Errors only (e = error)
map("n", "<leader>ej", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
map("n", "<leader>ek", diagnostic_goto(false, "ERROR"), { desc = "Prev error" })

-- Warnings only (w = warning)
map("n", "<leader>wj", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
map("n", "<leader>wk", diagnostic_goto(false, "WARN"), { desc = "Prev warning" })
