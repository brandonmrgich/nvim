return {
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
				-- Filter out certain buffers based on their number or other criteria
				-- Example: hide terminal buffers
				if vim.bo[buf_number].filetype == "terminal" then
					return false
				end
				return true
			end,
		},
	},
}
