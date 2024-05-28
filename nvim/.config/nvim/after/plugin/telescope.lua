local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pw', function()
    builtin.grep_string({ search = vim.fn.input("<cword>") })
end)
vim.keymap.set('n', '<leader>gc', function()
    require("adam.telescope").git_branches()
end)

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- todo reafctor
vim.keymap.set('n', '<leader>vrc', function()
    require("telescope.builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = vim.env.DOTFILES,
        hidden = true,
    })
end)


require("telescope").load_extension("harpoon")


vim.keymap.set("n", "<leader>gc", function()
    require('adam.telescope').git_branches()
end)
vim.keymap.set("n", "<leader>gw", function()
    require('telescope').extensions.git_worktree.git_worktrees()
end)
vim.keymap.set("n", "<leader>gm", function()
    require('telescope').extensions.git_worktree.create_git_worktree()
end)
vim.keymap.set("n", "<leader>td", function()
    require('theprimeagen.telescope').dev()
end)
