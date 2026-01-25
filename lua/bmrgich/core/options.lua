local vim = vim
local opt = vim.opt

-------------------------------------------------------------------------------
-- Providers
-------------------------------------------------------------------------------
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/bin/python3")
vim.g.perl_host_prog = vim.fn.exepath("perl")

-------------------------------------------------------------------------------
-- Global vim settings
-------------------------------------------------------------------------------
vim.g.autoformat = true

vim.g.deprecation_warnings = true

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`

vim.g.trouble_lualine = true

-------------------------------------------------------------------------------
-- General options
-------------------------------------------------------------------------------

-- Set text width for comments
opt.textwidth = 100
opt.formatoptions:append("t") -- Auto wrap text
opt.formatoptions:append("c") -- Format comments

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- TODO: Change
opt.wrap = true -- line wrapping

opt.linebreak = true -- Wrap lines at convenient points

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

opt.syntax = "on"
opt.encoding = "UTF-8"
opt.ruler = true
opt.title = true
opt.hidden = true
opt.ttimeoutlen = 0
opt.wildmenu = true
opt.showcmd = true
opt.showmatch = true
opt.inccommand = "split"
-- opt.inccommand = "nosplit" -- preview incremental substitute
opt.autowrite = true -- Enable auto write
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.foldlevel = 99
-- opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
-- opt.list = true -- Show some invisible characters (tabs...
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

-- if vim.fn.has("nvim-0.10") == 1 then
-- 	opt.smoothscroll = true
-- 	opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
-- 	opt.foldmethod = "expr"
-- 	opt.foldtext = ""
-- else
-- 	opt.foldmethod = "indent"
-- 	opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-------------------------------------------------------------------------------
-- Appearance
-------------------------------------------------------------------------------

-- opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]

-- turn on termguicolors for nighfly colorscheme to work
-- (must use true color terminal i.e. iterm2)
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- split windows
opt.splitright = true -- split to right
opt.splitbelow = true -- split down
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current

-- turn off swapfile
opt.swapfile = false

-- Netrw
vim.g.netrw_liststyle = 3 -- Change style
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"
