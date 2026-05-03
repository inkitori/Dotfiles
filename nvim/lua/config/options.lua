local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 250
opt.timeoutlen = 400

opt.undofile = true
opt.swapfile = false

opt.completeopt = { "menu", "menuone", "noselect" }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.fillchars = { eob = " " }
