vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
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

vim.opt.cmdheight = 1
vim.opt.updatetime = 50
vim.opt.shortmess:append("c")
-- Disable welcome screen (intro message)
vim.opt.shortmess:append("I")

-- Show statusline
vim.opt.laststatus = 2

-- Custom statusline with buffer name (left) and default info (right)
vim.opt.statusline = "%f %=%l:%c"

vim.opt.colorcolumn = "80"

-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"

vim.opt.wildignore = vim.opt.wildignore + "*.pyc"
vim.opt.wildignore = vim.opt.wildignore + "*_build/*"
vim.opt.wildignore = vim.opt.wildignore + "**/coverage/*"
vim.opt.wildignore = vim.opt.wildignore + "**/node_modules/*"
vim.opt.wildignore = vim.opt.wildignore + "**/android/*"
vim.opt.wildignore = vim.opt.wildignore + "**/ios/*"
vim.opt.wildignore = vim.opt.wildignore + "**/.git/*"
vim.opt.wildignore = vim.opt.wildignore + "**/.history/*"

vim.g.spelllang = "en_us"
vim.g.spell = true
vim.g.loaded_perl_provider = 0

vim.cmd([[autocmd BufEnter * set formatoptions-=o]])
