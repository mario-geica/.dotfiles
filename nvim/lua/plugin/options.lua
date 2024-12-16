vim.opt.guicursor = ""
vim.opt.clipboard="unnamedplus"
vim.opt.wrap = true

vim.opt.nu = true
vim.opt.relativenumber = false

vim.opt.errorbells = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300  -- Faster completion
vim.opt.mouse = 'a'  -- Enable mouse support
vim.opt.fileencoding = "utf-8"
