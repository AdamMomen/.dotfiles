return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "tsx",
                    "json",
                    "lua",
                    "html",
                    "css",
                    "markdown",
                    "markdown_inline",
                    "vim",
                    "vimdoc",
                    "bash",
                    "rust",
                    "python",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    -- Disable for help files and large files to avoid errors
                    disable = function(lang, buf)
                        -- Disable for help files (query compatibility issue with Neovim 0.11.5)
                        if lang == "help" or vim.bo[buf].filetype == "help" then
                            return true
                        end
                        -- Disable for large files
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
                indent = {
                    enable = true,
                },
            })
            
        end,
    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    },
}
