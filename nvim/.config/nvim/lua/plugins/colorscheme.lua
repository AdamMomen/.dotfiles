return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                integrations = {
                    cmp = true,
                    treesitter = true,
                    harpoon = true,
                    telescope = true,
                    mason = true,
                    -- lualine = true, -- Disabled
                    -- bufferline = true, -- Disabled
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
