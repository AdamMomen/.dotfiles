vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

vim.opt.colorcolumn = "80"


vim.opt.wildignore = vim.opt.wildignore + "*.pyc"
vim.opt.wildignore = vim.opt.wildignore + "*_build/*"
vim.opt.wildignore = vim.opt.wildignore + "**/coverage/*"
vim.opt.wildignore = vim.opt.wildignore + "**/node_modules/*"
vim.opt.wildignore = vim.opt.wildignore + "**/android/*"
vim.opt.wildignore = vim.opt.wildignore + "**/ios/*"
vim.opt.wildignore = vim.opt.wildignore + "**/.git/*"
vim.opt.wildignore = vim.opt.wildignore + "**/.history/*"

vim.g.mapleader = " "
vim.g.spelllang = 'en_us'
vim.g.spell = true
vim.g.loaded_perl_provider = 0
vim.cmd([[autocmd BufEnter * set formatoptions-=o]])
