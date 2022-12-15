call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'

" Yes, I am a sneaky snek now
Plug 'ambv/black'

Plug 'f-person/git-blame.nvim'

" -- Cht.sh --
Plug 'scrooloose/syntastic'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-cheat.sh'

" Plug 'vuciv/vim-bujo'
Plug 'chipsenkbeil/distant.nvim'

" -- Plebvim lsp Plugins --
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'tjdevries/nlua.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'mhartington/formatter.nvim'
Plug 'williamboman/nvim-lsp-installer'

" --  Completion --
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'mattn/emmet-vim'
Plug 'neovim/nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'github/copilot.vim' #TODO:enable me later
Plug 'glepnir/lspsaga.nvim'

" Colorizer
Plug 'norcalli/nvim-colorizer.lua'

" Neovim Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Debugger Plugins
" Plug 'puremourning/vimspector'
" Plug 'szw/vim-maximizer'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" Plug 'rust-lang/rust.vim'
Plug 'darrikonn/vim-gofmt'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'tpope/vim-dispatch'
Plug 'theprimeagen/vim-be-good'
Plug 'gruvbox-community/gruvbox'
Plug 'luisiacc/gruvbox-baby'
Plug 'tpope/vim-projectionist'


" Solidity
Plug 'tomlion/vim-solidity'

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'

Plug 'vim-conf-live/vimconflive2021-colorscheme'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'

" HARPOON!!
Plug 'ThePrimeagen/harpoon'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" prettier, what about other reviewers
Plug 'sbdchd/neoformat'

Plug 'derekwyatt/vim-scala', { 'for': 'scala' }

Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
" Plug 'hoob3rt/lualine.nvim'

" Leetcode
" Plug 'ianding1/leetcode.vim'
" Plug '8ooo8/leetcode'

" -- Github Integration --
Plug 'AdamMomen/vim-apm'
Plug 'pwntester/octo.nvim'

" Icons
Plug 'kyazdani42/nvim-web-devicons'
Plug 'yamatsum/nvim-nonicons', {'requires' :'kyazdani42/nvim-web-devicons'}

" -- Scala settings --
Plug 'scalameta/nvim-metals'

" -- Wakatime --
Plug 'wakatime/vim-wakatime'
call plug#end()
