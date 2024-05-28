local augroup = vim.api.nvim_create_augroup
local LspFormatingGroup = augroup('LspFormating', {})
local yank_group = augroup('HighlightYank', {})

local autocmd = vim.api.nvim_create_autocmd

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- autocmd({ "BufEnter" }, {
--     pattern = '*.tsx',
--     group = ts_highlight_tsx,
--     callback = function()
--         vim.api.nvim_command(":TSBufDisable highlight")
--     end,
-- })
 --vim.cmd [[
 --  augroup LspFormatting
 --    autocmd!
 --    autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx EslintFixAll
 --  augroup END
 --]]


autocmd({ "BufWritePre" }, {
    group = yank_group ,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

-- autocmd({ "Eslint" }, {
--     group = LspFormatingGroup,
--     pattern = "*.js,*.jsx,*.ts,*.tsx",
--     command = "EslintFixAll",
-- })

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
