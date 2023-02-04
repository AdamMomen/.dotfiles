require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "javascript", "typescript", "lua", "help", "rust"},

  sync_install = false,


  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
