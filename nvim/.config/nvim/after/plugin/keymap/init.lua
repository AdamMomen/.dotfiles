-- local window = require("twitchy.window")
-- local tmux = require("twitchy.window.tmux")
-- local tail = require("twitchy.window.tail")

local Remap = require("adam.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

nnoremap("<leader>e", ":Ex<CR>")
nnoremap("<leader>q", ":q<CR>")
nnoremap("<leader>u", ":UndotreeShow<CR>")

vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

nnoremap("Y", "yg$")
-- nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
nnoremap("<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
xnoremap("<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")

nnoremap("<leader>d", "\"_d")
vnoremap("<leader>d", "\"_d")

vnoremap("<leader>d", "\"_d")

-- This is going to get me cancelled
inoremap("<C-c>", "<Esc>")

nnoremap("Q", "<nop>")
nnoremap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
nnoremap("<leader>f", function()
    vim.lsp.buf.format()
end)

nnoremap("<C-k>", "<cmd>cnext<CR>zz")
nnoremap("<C-j>", "<cmd>cprev<CR>zz")
-- nnoremap("<leader>k", "<cmd>lnext<CR>zz")
-- nnoremap("<leader>j", "<cmd>lprev<CR>zz")
nnoremap("<C-j>", "<C-w>j")
nnoremap("<C-k>", "<C-w>k")
nnoremap("<C-l>", "<C-w>l")
nnoremap("<C-h>", "<C-w>h")

nnoremap("<leader>1", "<cmd>PackerSync<CR>")
nnoremap("<leader>2", "<cmd>e ~/.zshrc<CR>")
nnoremap("<leader>3", "<cmd>e ~/.zsh_profile<CR>")
nnoremap("<leader>5", "<cmd>e ~/.config/nvim/after/plugin/keymap/init.lua<CR>")
nnoremap("<leader>6", "<cmd>e ~/.config/nvim/after/plugin/lsp.lua<CR>")
nnoremap("<leader>7", "<cmd>e ~/.config/nvim/lua/adam/packer.lua<CR>")
nnoremap("<leader>8", "<cmd>e ~/.tmux.conf<CR>")

nnoremap("<leader>/", "<cmd>split<CR>")
nnoremap("<leader>\\", "<cmd>vsplit<CR>")
nnoremap("<leader>_lsp", ":LspInstallInfo<CR>")

-- Tab Momvent
nmap("te", "<cmd>tabedit<CR>")
nmap("<", "<cmd>tabprev<Return>")
nmap(">", "<cmd>tabnext<Return>")


-- Window resizing
nmap("<leader><left>", "<C-w>>")
nmap("<leader><right>", "<C-w><")
nmap("<leader><up>",  "<C-w>+")
nmap("<leader><down>", "<C-w>-")

nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

nnoremap("<leader>tc", function()
 -- tail.reset()
 -- tmux.reset()
end);

nnoremap("<leader>ta", function()
    -- tail.reset()
 --   tmux.reset()
end);
nnoremap("<leader>ww", "ofunction wait(ms: number): Promise<void> {<CR>return new Promise(res => setTimeout(res, ms));<CR>}<esc>k=i{<CR>")
