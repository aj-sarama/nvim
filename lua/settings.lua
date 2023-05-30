-- EDITOR SETTINGS

vim.opt.mouse = ""

-- read file when changed outside of vim
vim.opt.autoread = true

-- tab related settings
vim.opt.expandtab = true       -- use spaces instead of tabs
vim.opt.tabstop = 4            -- how many spaces a tab counts for
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4         -- number of spaces to use for an autoindent

-- no line wrapping
vim.opt.wrap = false

-- no swapfile
vim.opt.swapfile = false
vim.opt.backup = false

-- undo settings
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search settings
vim.opt.hlsearch = false       -- don't highlight searches
vim.opt.incsearch = true       -- move cursor to matches as they are typed
vim.opt.smartcase = true       -- ignore case in lowecase patterns

-- colors
vim.opt.termguicolors = true

-- scroll settings
vim.opt.scrolloff = 8

-- relative and global line numbers
vim.opt.nu = true
vim.opt.relativenumber = false

-- use box cursor
vim.opt.guicursor = "" 

-- fast update time (for cursorhold event)
vim.opt.updatetime = 50

-- colorcolumn to mark 80 characters
--vim.opt.colorcolumn = "80"

--vim.opt.list = true
--vim.opt.listchars:append "eol:↴"
