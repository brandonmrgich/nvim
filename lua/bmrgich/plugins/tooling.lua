-- Tooling: terminal, git, sessions, utilities
return {
	-- ToggleTerm: floating terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 10,
			open_mapping = [[<leader>bash]],
			shading_factor = 2,
			direction = "float",
			float_opts = {
				border = "curved",
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		},
	},

	-- Diffview: side-by-side diff viewer for working tree and git history
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open git diff view" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close git diff view" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File git history" },
		},
	},

	-- LazyGit: git TUI
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
		},
	},

	-- Auto-session: workspace persistence
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				auto_restore_enabled = false,
				auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
			})

			vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
			vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
		end,
	},

	-- Venv-selector: Python virtual environment picker
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python",
		},
		branch = "regexp",
		cmd = "VenvSelect",
		config = function()
			require("venv-selector").setup({
				settings = {
					search = {
						my_venvs = {
							command = "fd python$ $CWD --full-path --color never -E /proc -I -a -L",
						},
					},
				},
			})
		end,
		keys = {
			{ ",v", "<cmd>VenvSelect<cr> <cmd>LspRestart<cr>" },
		},
	},

	-- Which-key: keymap hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Todo-comments: highlight and search TODOs
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local todo_comments = require("todo-comments")
			todo_comments.setup()

			vim.keymap.set("n", "]t", function()
				todo_comments.jump_next()
			end, { desc = "Next todo comment" })
			vim.keymap.set("n", "[t", function()
				todo_comments.jump_prev()
			end, { desc = "Previous todo comment" })
		end,
	},

	-- Discord rich presence
	{
		"andweeb/presence.nvim",
		event = "VeryLazy",
	},

	-- Glow: markdown preview
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		opts = {},
	},

	-- LeetCode
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		cmd = "Leet",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
}
