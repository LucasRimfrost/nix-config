-- lua/plugins/treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
		},
		config = function()
			require("nvim-treesitter").setup()

			-- Enable treesitter highlighting
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					if lang and vim.treesitter.language.add(lang) then
						vim.treesitter.start(args.buf, lang)
					end
				end,
			})

			local ensure_installed = {
				"c",
				"cpp",
				"rust",
				"python",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"bash",
				"markdown",
				"markdown_inline",
				"json",
				"toml",
				"yaml",
				"cmake",
				"make",
				"latex",
				"bibtex",
				"java",
			}

			-- install listed parsers on startup
			vim.schedule(function()
				for _, lang in ipairs(ensure_installed) do
					local ok = pcall(vim.treesitter.language.inspect, lang)
					if not ok then
						pcall(function()
							vim.cmd("TSInstall " .. lang)
						end)
					end
				end
			end)

			-- disable treesitter on large files
			vim.api.nvim_create_autocmd("BufReadPost", {
				callback = function(args)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok and stats and stats.size > max_filesize then
						vim.treesitter.stop(args.buf)
						vim.notify(
							"File larger than 100KB, treesitter disabled",
							vim.log.levels.WARN,
							{ title = "Treesitter" }
						)
					end
				end,
			})

			-- treesitter indent
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					if vim.treesitter.language.get_lang(vim.bo.filetype) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- incremental selection
			vim.keymap.set("n", "<Enter>", function()
				require("nvim-treesitter.incremental_selection").init_selection()
			end, { desc = "Init treesitter selection" })
			vim.keymap.set("x", "<Enter>", function()
				require("nvim-treesitter.incremental_selection").node_incremental()
			end, { desc = "Increment treesitter selection" })
			vim.keymap.set("x", "<BS>", function()
				require("nvim-treesitter.incremental_selection").node_decremental()
			end, { desc = "Decrement treesitter selection" })

			-- treesitter-context
			require("treesitter-context").setup({
				enable = true,
				max_lines = 3,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
			})
		end,
	},
}
