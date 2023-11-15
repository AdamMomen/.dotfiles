vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("n", "<leader>e", ":Ex<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
-- vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)

vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest keymap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest keymap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>h", "<C-w>h")

vim.keymap.set("n", "<leader>1", "<cmd>PackerSync<CR>")
vim.keymap.set("n", "<leader>2", "<cmd>e ~/.zshrc<CR>")
vim.keymap.set("n", "<leader>3", "<cmd>e ~/.zsh_profile<CR>")
vim.keymap.set("n", "<leader>5", "<cmd>e ~/.config/nvim/after/plugin/keymap/init.lua<CR>")
vim.keymap.set("n", "<leader>6", "<cmd>e ~/.config/nvim/after/plugin/lsp.lua<CR>")
vim.keymap.set("n", "<leader>7", "<cmd>e ~/.config/nvim/lua/adam/packer.lua<CR>")
vim.keymap.set("n", "<leader>8", "<cmd>e ~/.tmux.conf<CR>")

vim.keymap.set("n", "<leader>/", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<leader>m", ":Mason<CR>")

-- Tab Momvent
vim.keymap.set("n", "<", "<cmd>tabprev<Return>")
vim.keymap.set("n", ">", "<cmd>tabnext<Return>")


-- Window resizing
vim.keymap.set("n", "<leader><left>", "<C-w>>")
vim.keymap.set("n", "<leader><right>", "<C-w><")
vim.keymap.set("n", "<leader><up>", "<C-w>+")
vim.keymap.set("n", "<leader><down>", "<C-w>-")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


vim.keymap.set("n", "<leader>ww", "ofunction wait(ms: number): Promise<void> {<CR>return new Promise(res => setTimeout(res, ms));<CR>}<esc>k=i{<CR>");
