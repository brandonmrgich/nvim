-- UI: colorscheme, statusline, treesitter, bufferline, visual enhancements
return {
	-- Colorscheme
	{
		"tiagovla/tokyodark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme tokyodark")
		end,
	},

	-- Treesitter: syntax highlighting and text objects
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = false },
				autotag = { enable = true },
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"dockerfile",
					"graphql",
					"html",
					"java",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"rust",
					"svelte",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})
		end,
	},

	-- Lualine: statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lazy_status = require("lazy.status")

			local colors = {
				blue = "#65D1FF",
				green = "#3EFFDC",
				violet = "#FF61EF",
				yellow = "#FFDA7B",
				red = "#FF4A4A",
				fg = "#c3ccdc",
				bg = "#112638",
				inactive_bg = "#2c3043",
			}

			local my_theme = {
				normal = {
					a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = {
					a = { bg = colors.green, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
					b = { bg = colors.inactive_bg, fg = colors.fg },
					c = { bg = colors.inactive_bg, fg = colors.fg },
				},
			}

			require("lualine").setup({
				options = { theme = my_theme },
				sections = {
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						{ "encoding" },
						{ "fileformat" },
						{ "filetype" },
					},
				},
			})
		end,
	},

	-- Bufferline: tab/buffer line
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		version = "*",
		opts = {
			options = {
				mode = "tabs",
				separator_style = "slant",
				always_show_bufferline = true,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				custom_filter = function(buf_number)
					if vim.bo[buf_number].filetype == "terminal" then
						return false
					end
					return true
				end,
			},
		},
	},

	-- Gitsigns: git integration in the sign column
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				map("n", "]h", gs.next_hunk, "Next Hunk")
				map("n", "[h", gs.prev_hunk, "Prev Hunk")
				map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
				map("n", "<leader>gv", gs.diffthis, "View inline diff")
				map("n", "<leader>gV", function()
					gs.diffthis("~")
				end, "View inline diff vs HEAD~")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
			end,
		},
	},

	-- Dressing: better vim.ui interfaces
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},

	-- Colorizer: inline color preview (catgoose fork — maintained, fixes vim.tbl_flatten deprecation)
	{
		"catgoose/nvim-colorizer.lua",
		event = "VeryLazy",
		opts = { filetypes = { "*" } },
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "┊" },
		},
	},

	-- Markdown rendering: rich in-buffer display for .md files
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			-- Neovim 0.12.1 bug: TSNode:range() is nil on stale nodes produced
			-- by the markdown injection query (fenced code block language detection).
			-- Clearing the injection query prevents the crash. render-markdown
			-- handles code block rendering through its own pipeline.
			vim.treesitter.query.set("markdown", "injections", "")
		end,
		opts = {
			heading = {
				enabled = true,
				sign = false,
				icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
			},
			code = {
				enabled = true,
				sign = false,
				style = "full",
				width = "block",
				border = "thin",
			},
			bullet = { enabled = true },
			checkbox = { enabled = true },
			table = { enabled = true },
		},
		keys = {
			{
				"<leader>tm",
				"<cmd>RenderMarkdown toggle<cr>",
				ft = "markdown",
				desc = "Toggle Markdown Render",
			},
		},
	},
}
