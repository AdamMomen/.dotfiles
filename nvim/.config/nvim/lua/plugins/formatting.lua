return {
    -- Formatting with conform.nvim (replaces null-ls formatting)
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
            },
            -- Uncomment to enable format on save
            -- format_on_save = {
            --     timeout_ms = 500,
            --     lsp_fallback = true,
            -- },
        },
    },

    -- Linting with nvim-lint (replaces null-ls linting)
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                -- Use ESLint LSP for linting instead of eslint_d
                -- javascript = { "eslint_d" },
                -- javascriptreact = { "eslint_d" },
                -- typescript = { "eslint_d" },
                -- typescriptreact = { "eslint_d" },
            }

            -- Create autocommand for linting
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
