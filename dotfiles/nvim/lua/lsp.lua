vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

-- c
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
  },
})

-- python
vim.lsp.config("pyright", {
  settings = {
    pyright = {
      -- let ruff own import sorting
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        typeCheckingMode = "basic",       -- bump to "standard" or "strict" for more rigor
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly", -- "workspace" checks the whole project (heavier)
      },
    },
  },
})

-- python (ruff)
vim.lsp.config("ruff", {
  init_options = {
    settings = {
      lineLength = 88,
    },
  },
})

-- rust
vim.lsp.config("rust_analyzer", {
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      -- clippy is just better
      check = {
        command = "clippy",
      },
      -- off by default (very much needed)
      procMacro = {
        enable = true,
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
        allFeatures = true,
      },
    },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- nix
vim.lsp.config("nixd", {
  settings = {
    nixd = {
      formatting = { command = { "nixfmt" } },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "nixd",
  "clangd",
  "pyright",
  "ruff",
  "rust_analyzer",
  "jdtls",
})
