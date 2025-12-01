return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- Icons for telescope (loaded early in editor.lua)
            "xiyaowong/telescope-emoji.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
                -- Enable icons in telescope
                defaults = {
                    prompt_prefix = "  ",
                    selection_caret = "  ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "bottom",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                },
            })
            telescope.load_extension("emoji")

            -- Keymaps
            vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Git files" })
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end, { desc = "Grep string" })
            vim.keymap.set("n", "<leader>pg", builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Help tags" })
        end,
    },
}
