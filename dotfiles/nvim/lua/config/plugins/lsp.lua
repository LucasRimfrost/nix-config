-- lua/config/plugins/lsp.lua
-- NixOS: language servers are installed via Nix (modules/home/dev.nix) and live
-- on PATH. Mason is removed entirely — its downloaded binaries don't run on
-- NixOS. nvim-lspconfig is kept only as a lightweight load-timing anchor; the
-- actual configs below are native Neovim (vim.lsp.config / vim.lsp.enable).
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "saghen/blink.cmp" },
	config = function()
		-- Capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Python
		vim.lsp.config("pyright", {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			root_markers = {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				"pyrightconfig.json",
				".git",
			},
			capabilities = capabilities,
		})

		-- C/C++
		vim.lsp.config("clangd", {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
			root_markers = {
				"compile_commands.json",
				"compile_flags.txt",
				".clangd",
				".clang-tidy",
				".clang-format",
				"CMakeLists.txt",
				"Makefile",
				"configure.ac",
				".git",
			},
			capabilities = capabilities,
		})

		-- Rust (rust-analyzer from Nix, on PATH)
		vim.lsp.config("rust_analyzer", {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_markers = {
				"Cargo.toml",
				"rust-project.json",
			},
			capabilities = capabilities,
		})

		-- Lua
		vim.lsp.config("lua_ls", {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = {
				".luarc.json",
				".luarc.jsonc",
				".luacheckrc",
				".stylua.toml",
				"stylua.toml",
				"selene.toml",
				".git",
			},
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		-- LaTeX (texlab from Nix, on PATH)
		vim.lsp.config("texlab", {
			cmd = { "texlab" },
			filetypes = { "tex", "bib" },
			root_markers = {
				".latexmkrc",
				".git",
			},
			capabilities = capabilities,
			settings = {
				texlab = {
					auxDirectory = "build",
					bibtexFormatter = "texlab",
					build = {
						onSave = false,
					},
					forwardSearch = {
						executable = nil,
					},
				},
			},
		})

		-- Enable configured servers (they start only for matching filetypes).
		-- jdtls is intentionally absent — nvim-jdtls manages it (see jdtls.lua).
		vim.lsp.enable({ "pyright", "clangd", "rust_analyzer", "lua_ls", "texlab" })
	end,
}
