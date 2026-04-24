-- Set leaders as early as possible (before any mappings/plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("bmrgich.core")
require("bmrgich.lazy")
