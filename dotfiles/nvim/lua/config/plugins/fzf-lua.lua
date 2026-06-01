-- lua/plugins/fzf-lua.lua
return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			"default",
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				border = "rounded",
				backdrop = 60,
				preview = {
					border = "rounded",
					layout = "flex",
					flip_columns = 120,
					scrollbar = "float",
				},
			},
			fzf_colors = true,
			files = {
				cwd_prompt = true,
				hidden = true,
			},
			grep = {
				rg_glob = true,
				hidden = true,
			},
			lsp = {
				jump1 = true,
			},
		})

		-- register as vim.ui.select handler (used by code actions, etc.)
		fzf.register_ui_select()

		local map = vim.keymap.set

		-- project files
		map("n", "<leader>pf", fzf.files, { desc = "Find files" })
		map("n", "<C-p>", fzf.git_files, { desc = "Git files" })

		-- search
		map("n", "<leader>ps", fzf.grep, { desc = "Grep (with prompt)" })
		map("n", "<leader>pw", fzf.grep_cword, { desc = "Grep word under cursor" })
		map("n", "<leader>pW", fzf.grep_cWORD, { desc = "Grep WORD under cursor" })
		map("n", "<leader>pg", fzf.live_grep, { desc = "Live grep" })

		-- buffers and history
		map("n", "<leader>pb", fzf.buffers, { desc = "Buffers" })
		map("n", "<leader>po", fzf.oldfiles, { desc = "Old files" })

		-- help
		map("n", "<leader>vh", fzf.helptags, { desc = "Help tags" })

		-- extras
		map("n", "<leader>pr", fzf.resume, { desc = "Resume last picker" })
		map("n", "<leader>pd", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })

		-- search in specific directories
		map("n", "<leader>fn", function()
			fzf.files({ cwd = "~/.config/nvim" })
		end, { desc = "Find files in nvim config" })

		map("n", "<leader>fh", function()
			fzf.files({ cwd = "~" })
		end, { desc = "Find files in home" })

		map("n", "<leader>fc", function()
			fzf.files({ cwd = "~/.config" })
		end, { desc = "Find files in .config" })

		map("n", "<leader>gn", function()
			fzf.live_grep({ cwd = "~/.config/nvim" })
		end, { desc = "Grep in nvim config" })
	end,
}
