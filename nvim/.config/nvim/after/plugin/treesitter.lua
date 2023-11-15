require('nvim-treesitter.configs').setup {
    ensure_installed = { "javascript", "typescript", "rust", "c", "lua", "vim", "vimdoc", "query", "python" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
    folding = {
        enable = true, -- Enable Treesitter folding
    },
}
