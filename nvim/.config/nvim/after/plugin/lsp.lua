local Remap = require("adam.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("nvim-lsp-installer").setup {}
lspkind.init()

cmp.setup({
    experimental = {
        ghost_text = true,
        native_menu = false,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<c-e>"] = cmp.mapping(function(fallback)
            local copilot_keys = vim.fn['copilot#Accept']()
            if copilot_keys ~= '' and type(copilot_keys) == 'string' then
                vim.api.nvim_feedkeys(copilot_keys, 'i', true)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<c-u>"] = cmp.mapping.scroll_docs(-4),
        ["<c-d>"] = cmp.mapping.scroll_docs(4),
        ["<c-c>"] = cmp.mapping.close(),
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

    },
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[lua]",
                cmp_tabnine = "[TN]",
                path = "[path]",
                luasnip = "[snip]",
            }
        },
    },

    sources = {
        -- { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "cmp_tabnine" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
    },
})

local tabnine = require('cmp_tabnine.config')
tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
})


local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function()
            nnoremap("gd", function() vim.lsp.buf.definition() end)
            nnoremap("gi", function() vim.lsp.buf.implementation() end)
            nnoremap("vh", function() vim.lsp.buf.hover() end)
            nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
            nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
            nnoremap("[d", function() vim.diagnostic.goto_next() end)
            nnoremap("]d", function() vim.diagnostic.goto_prev() end)
            nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
            nnoremap("<leader>vco", function() vim.lsp.buf.code_action({
                    filter = function(code_action)
                        if not code_action or not code_action.data then
                            return false
                        end

                        local data = code_action.data.id
                        return string.sub(data, #data - 1, #data) == ":0"
                    end,
                    apply = true
                })
            end)
            nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
            nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
            inoremap("<leader>vsh>", function() vim.lsp.buf.signature_help() end)
        end,
    }, _config or {})
end

--require'lspconfig'.solang.setup(config())
require('lspconfig').tsserver.setup(config())
require('lspconfig').solidity_ls.setup(config())
require 'lspconfig'.cssls.setup(config())
require 'lspconfig'.jsonls.setup(config())
require('lspconfig').eslint.setup(config(
    {
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "solidity",
            "json"
        }
    }
))

require 'lspconfig'.html.setup(config())
require 'lspconfig'.cssmodules_ls.setup(config())
-- require 'lspconfig'.arduino_language_server.setup(config(
--    { cmd = { "/opt/homebrew/bin/arduino-cli" } }
--))
--require 'lspconfig'.arduino_language_server.setup(config({
--    cmd = {
--        "arduino-language-server",
--        "-cli-config", "/Users/adam/Library/Arduino15/arduino-cli.yaml",
--        "-fqbn", "esp8266:esp8266:nodemcu",
--        "-cli", "/opt/homebrew/bin/arduino-cli",
--        "-clangd", "/usr/bin/clangd",
--    }
--}))

-- require 'lspconfig'.clangd.setup(config({
--     cmd = { "clangd", "--background-index", "--clang-tidy" },
--     root_dir = function() return vim.loop.cwd() end
-- }))

require 'lspconfig'.jedi_language_server.setup(config())
-- require 'lspconfig'.metals.setup(config())
require 'lspconfig'.pylsp.setup(config())
require 'lspconfig'.grammarly.setup(config())
require 'lspconfig'.tailwindcss.setup(config(
    {
        includeLanguages = { "jsx" }
    }
))

-- require'lspconfig'.pylsp.setup(config({
--   settings = {
--         formatting = {"black"},
--         pylsp = {
--             plugins = {
--                     pylint = {
--                         enabled = true,
--                         executable = 'pylint',
--                         args={'--rcfile', '~/.pylintrc'}
--                     },
--                 },
--             },
--         }
--   })
-- )
-- require'lspconfig'.svelte.setup(config())
-- require'lspconfig'.yamlls.setup(config())
-- require'lspconfig'.gopls.setup(config({
--    cmd = {"gopls", "serve"},
--    filetypes = { "go", "gomod", "gotmpl" },
--    settings = {
--        gopls = {
--            analyses = {
--                unusedparams = true,
--            },
--            staticcheck = true,
--        },
--    },
-- }))

-- who even uses this?
-- require'lspconfig'.rust_analyzer.setup(config({}))

require 'lspconfig'.sumneko_lua.setup(config({
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
}))

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}

require('symbols-outline').setup(opts)

local snippets_paths = function()
    local plugins = { "friendly-snippets" }
    local paths = {}
    local path
    local root_path = vim.env.HOME .. '/.vim/plugged/'
    for _, plug in ipairs(plugins) do
        path = root_path .. plug
        if vim.fn.isdirectory(path) ~= 0 then
            table.insert(paths, path)
        end
    end
    return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
    paths = snippets_paths(),
    include = nil, -- Load all languages
    exclude = {}
})
