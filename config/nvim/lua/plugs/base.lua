local Plug = vim.fn['plug#']

vim.call('plug#begin', "~/.config/nvim/plugged")

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make' })

Plug 'tamago324/lir.nvim'

Plug 'rcarriga/nvim-notify'

Plug 'chriskempson/base16-vim'
Plug 'caglartoklu/borlandp.vim'
Plug 'eddyekofo94/gruvbox-flat.nvim'

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons' -- Recommended (for coloured icons)
Plug 'akinsho/nvim-bufferline.lua'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/trouble.nvim'

Plug 'roman/golden-ratio' -- C-W \

Plug 'unblevable/quick-scope' -- f F t T
-- Plug 'justinmk/vim-sneak'     " s or z with an operator
Plug 'ggandor/lightspeed.nvim'

Plug 'danilamihailov/beacon.nvim'

Plug 'machakann/vim-sandwich' -- sa sd sr
Plug 'tmsvg/pear-tree'

-- Plug 'justinmk/vim-dirvish' -- leader f

-- Plug 'glepnir/dashboard-nvim'

Plug 'EinfachToll/DidYouMean'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-apathy' -- ]f

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify' -- ]c [c

Plug 'sheerun/vim-polyglot'

Plug('nvim-treesitter/nvim-treesitter', { ["do"] = ':TSUpdate' })
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'p00f/nvim-ts-rainbow'
Plug 'romgrk/nvim-treesitter-context'

Plug 'tpope/vim-abolish'
Plug 'tomtom/tcomment_vim' -- gc

Plug 'dyng/ctrlsf.vim' -- leader /
Plug 'RRethy/vim-illuminate'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

-- For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'vimwiki/vimwiki'

Plug('severin-lemaignan/vim-minimap', { on = 'Minimap' })
Plug('itchyny/calendar.vim', { on = 'Calendar' })
Plug('mtth/scratch.vim', { on = 'Scratch' }) -- gs

require('mong8se').loadRCFiles('plugs')

vim.call('plug#end')
