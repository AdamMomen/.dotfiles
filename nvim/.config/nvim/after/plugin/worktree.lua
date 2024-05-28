local ok, worktree = pcall(require, "git-worktree")
if not ok then
    return
end

worktree.setup()

local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

telescope.load_extension("git_worktree")

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>gw', "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", options)
