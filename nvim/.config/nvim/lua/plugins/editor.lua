return {
    -- Harpoon for quick file navigation
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon add file" })
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon menu" })

            vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
            vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })
            vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end, { desc = "Harpoon file 3" })
            vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end, { desc = "Harpoon file 4" })
        end,
    },

    -- Undotree
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
        },
    },

    -- Git integration
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
        keys = {
            { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
        },
    },

    -- Git worktree
    {
        "ThePrimeagen/git-worktree.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("git-worktree").setup({})
            require("telescope").load_extension("git_worktree")

            vim.keymap.set("n", "<leader>gwl", function()
                require("telescope").extensions.git_worktree.git_worktrees()
            end, { desc = "Git worktrees" })
            vim.keymap.set("n", "<leader>gwc", function()
                require("telescope").extensions.git_worktree.create_git_worktree()
            end, { desc = "Create worktree" })
        end,
    },

    -- Icons (load early so other plugins can use them)
    -- NOTE: Icons require a Nerd Font to be installed and set as your terminal font
    -- Install from: https://www.nerdfonts.com/
    -- Popular options: FiraCode Nerd Font, JetBrains Mono Nerd Font, MesloLGS NF
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false, -- Load immediately so icons are available
        priority = 1000, -- Load very early
        config = function()
            require("nvim-web-devicons").setup({
                -- Enable default icons
                override = {},
                -- Enable color icons
                color_icons = true,
                -- Set default icon
                default = true,
                -- Strict mode (only show icons for recognized file types)
                strict = false,
            })
        end,
    },

    -- Fun
    {
        "eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
    },
}
