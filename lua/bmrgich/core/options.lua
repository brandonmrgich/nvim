local opt = vim.opt

vim.g.python3_host_prog = "~/.config/nvim/venv/bin/python3"
vim.g.loaded_perl_provider = "/opt/homebrew/bin/perl"

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-------------
-- appearance
-------------

-- turn on termguicolors for nighfly colorscheme to work
-- (must use true color terminal i.e. iterm2)
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split to right
opt.splitbelow = true -- split down

-- turn off swapfile
opt.swapfile = false

-------------
-- Netrw Tree
-------------

-- Change style
vim.g.netrw_liststyle = 3

-- netrw configuration
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"

opt.syntax = "on"
opt.encoding = "UTF-8"
opt.ruler = true
opt.mouse = "a"
opt.title = true
opt.hidden = true
opt.ttimeoutlen = 0
opt.wildmenu = true
opt.showcmd = true
opt.showmatch = true
opt.inccommand = "split"
