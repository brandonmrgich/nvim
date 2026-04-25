local opt = vim.opt

-------------------------------------------------------------------------------
-- Providers
-------------------------------------------------------------------------------
vim.g.python3_host_prog = vim.fn.stdpath("config") .. "/venv/bin/python3"
vim.g.perl_host_prog = vim.fn.exepath("perl")

-------------------------------------------------------------------------------
-- Global vim settings
-------------------------------------------------------------------------------
vim.g.autoformat = true
vim.g.deprecation_warnings = true

-- BigFile threshold: files larger than this get the "bigfile" filetype
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Show document symbols from Trouble in lualine
vim.g.trouble_lualine = true

-------------------------------------------------------------------------------
-- General options
-------------------------------------------------------------------------------

opt.textwidth = 100
opt.formatoptions = "jcroqlnt"

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true

-- Wrapping
opt.wrap = true
opt.linebreak = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Cursor
opt.cursorline = true

-- Editing behavior
opt.backspace = "indent,eol,start"
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.autowrite = true
opt.virtualedit = "block"

-- UI
opt.syntax = "on"
opt.encoding = "UTF-8"
opt.ruler = true
opt.title = true
opt.hidden = true
opt.ttimeoutlen = 50
opt.wildmenu = true
opt.showcmd = true
opt.showmatch = true
opt.showmode = false
opt.inccommand = "split"
opt.conceallevel = 2
opt.pumblend = 10
opt.pumheight = 10
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.laststatus = 3
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.jumpoptions = "view"

-- Timeouts
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.updatetime = 200

-- Persistence
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Shortmess
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Spelling
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")

-- Folds
opt.foldlevel = 99
opt.fillchars = {
	fold = " ",
	diff = "╱",
	eob = " ",
}

-------------------------------------------------------------------------------
-- Appearance
-------------------------------------------------------------------------------
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Split windows
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-------------------------------------------------------------------------------
-- Netrw
-------------------------------------------------------------------------------
vim.g.netrw_liststyle = 3
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"

-- Markdown
vim.g.markdown_recommended_style = 0
