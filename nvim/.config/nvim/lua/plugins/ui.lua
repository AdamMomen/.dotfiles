return {
    -- Which-key for keybinding discoverability
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- Your configuration here (defaults are usually fine)
        },
    },

    -- Statusline (lualine) - Disabled, using default vim statusline
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     config = function()
    --         -- Custom theme matching tmux (bg=#333333, fg=#5eacd3)
    --         local custom_theme = {
    --             normal = {
    --                 a = { bg = "#333333", fg = "#5eacd3", gui = "bold" },
    --                 b = { bg = "#333333", fg = "#5eacd3" },
    --                 c = { bg = "#333333", fg = "#5eacd3" },
    --             },
    --             insert = {
    --                 a = { bg = "#333333", fg = "#5eacd3", gui = "bold" },
    --                 b = { bg = "#333333", fg = "#5eacd3" },
    --                 c = { bg = "#333333", fg = "#5eacd3" },
    --             },
    --             visual = {
    --                 a = { bg = "#333333", fg = "#5eacd3", gui = "bold" },
    --                 b = { bg = "#333333", fg = "#5eacd3" },
    --                 c = { bg = "#333333", fg = "#5eacd3" },
    --             },
    --             replace = {
    --                 a = { bg = "#333333", fg = "#5eacd3", gui = "bold" },
    --                 b = { bg = "#333333", fg = "#5eacd3" },
    --                 c = { bg = "#333333", fg = "#5eacd3" },
    --             },
    --             command = {
    --                 a = { bg = "#333333", fg = "#5eacd3", gui = "bold" },
    --                 b = { bg = "#333333", fg = "#5eacd3" },
    --                 c = { bg = "#333333", fg = "#5eacd3" },
    --             },
    --             inactive = {
    --                 a = { bg = "#333333", fg = "#5eacd3" },
    --                 b = { bg = "#333333", fg = "#5eacd3" },
    --                 c = { bg = "#333333", fg = "#5eacd3" },
    --             },
    --         }

    --         require("lualine").setup({
    --             options = {
    --                 icons_enabled = false, -- Disable icons to reduce visual clutter
    --                 theme = custom_theme,
    --                 component_separators = { left = "", right = "" },
    --                 section_separators = { left = "", right = "" },
    --                 disabled_filetypes = {
    --                     statusline = {},
    --                     winbar = {},
    --                 },
    --                 always_divide_middle = false,
    --                 globalstatus = true, -- Use single statusline for all windows
    --             },
    --             sections = {
    --                 lualine_a = { "mode" },
    --                 lualine_b = { "filename" },
    --                 lualine_c = {},
    --                 lualine_x = {},
    --                 lualine_y = {
    --                     function()
    --                         return vim.fn.line(".") .. ":" .. vim.fn.col(".")
    --                     end,
    --                 },
    --                 lualine_z = { "progress" },
    --             },
    --             inactive_sections = {
    --                 lualine_a = {},
    --                 lualine_b = { "filename" },
    --                 lualine_c = {},
    --                 lualine_x = {},
    --                 lualine_y = {
    --                     function()
    --                         return vim.fn.line(".") .. ":" .. vim.fn.col(".")
    --                     end,
    --                 },
    --                 lualine_z = {},
    --             },
    --             tabline = {},
    --             winbar = {},
    --             inactive_winbar = {},
    --             extensions = {},
    --         })
    --     end,
    -- },

    -- Bufferline (buffer tabs) - Disabled
    -- {
    --     "akinsho/bufferline.nvim",
    --     version = "*",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     config = function()
    --         require("bufferline").setup({
    --             options = {
    --                 mode = "buffers",
    --                 separator_style = "thin",
    --                 always_show_bufferline = true,
    --                 show_buffer_close_icons = true,
    --                 show_close_icon = true,
    --                 color_icons = true,
    --                 diagnostics = "nvim_lsp",
    --                 diagnostics_update_in_insert = false,
    --                 diagnostics_indicator = function(count, level, diagnostics_dict, context)
    --                     local icon = level:match("error") and " " or " "
    --                     return " " .. icon .. count
    --                 end,
    --                 offsets = {
    --                     {
    --                         filetype = "nvim-tree",
    --                         text = "File Explorer",
    --                         text_align = "left",
    --                         separator = true,
    --                     },
    --                 },
    --             },
    --         })

    --         -- Keybindings for bufferline
    --         vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
    --         vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    --         vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
    --         vim.keymap.set("n", "<leader>bd", "<cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
    --     end,
    -- },

    -- File explorer (nvim-tree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local api = require("nvim-tree.api")
            
            require("nvim-tree").setup({
                view = {
                    width = 30,
                },
                renderer = {
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = "✗",
                                staged = "✓",
                                unmerged = "⌥",
                                renamed = "➜",
                                untracked = "★",
                                deleted = "⊖",
                                ignored = "◌",
                            },
                        },
                    },
                },
                git = {
                    enable = true,
                },
                -- Configure keybindings
                on_attach = function(bufnr)
                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end

                    -- Default mappings
                    vim.keymap.set("n", "%", api.fs.create, opts("Create File"))
                    vim.keymap.set("n", "a", api.fs.create, opts("Create File or Folder"))
                    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
                    vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
                    vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
                    vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
                    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
                    vim.keymap.set("n", "y", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
                    vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
                    vim.keymap.set("n", "<C-r>", api.fs.rename_basename, opts("Rename: Basename"))
                    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
                    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
                    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
                    vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
                    vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
                    vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
                    vim.keymap.set("n", "q", api.tree.close, opts("Close"))
                    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
                end,
            })

            -- Toggle nvim-tree with leader+e, focusing on current file
            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer (current file)" })
        end,
    },
}
