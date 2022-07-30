require('packer').startup(function(use)
  use(vim.env.DOTFILES_RESOURCES.."/packer.nvim")

  use 'mong8se/buffish.nvim'
  -- use '~/Projects/buffish.nvim'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run='make' }

  use 'tamago324/lir.nvim'

  use 'rcarriga/nvim-notify'

  use 'RRethy/nvim-base16'
  use 'caglartoklu/borlandp.vim'
--   use 'eddyekofo94/gruvbox-flat.nvim'
  use 'ellisonleao/gruvbox.nvim'

  use 'tpope/vim-rsi'
  use 'tpope/vim-repeat'

  use 'folke/which-key.nvim'
  use 'hoob3rt/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons' -- Recommended (for coloured icons)
  use 'lukas-reineke/indent-blankline.nvim'
  use 'folke/trouble.nvim'

  use 'roman/golden-ratio' -- C-W \

  use 'unblevable/quick-scope' -- f F t T
  use 'ggandor/leap.nvim'

  use 'danilamihailov/beacon.nvim'

  use 'echasnovski/mini.nvim'
--   use 'machakann/vim-sandwich' -- sa sd sr
  use 'tmsvg/pear-tree'

  use 'EinfachToll/DidYouMean'
  use 'airblade/vim-rooter'
  use 'tpope/vim-apathy' -- ]f

  use 'lewis6991/gitsigns.nvim'

  use 'sheerun/vim-polyglot'

  use {'nvim-treesitter/nvim-treesitter', run=':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'p00f/nvim-ts-rainbow'

  use 'tpope/vim-abolish'
  use 'numToStr/Comment.nvim' -- gc

  use 'dyng/ctrlsf.vim' -- leader /
  use 'RRethy/vim-illuminate'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

-- For vsnip users.
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'

  use 'vimwiki/vimwiki'

  use { 'wfxr/minimap.vim', cmd='Minimap', run='cargo install --locked code-minimap' }
  use { 'itchyny/calendar.vim', cmd='Calendar' }
  use { 'mtth/scratch.vim', cmd='Scratch' } -- gs

  require('mong8se').loadRCFiles('plugs')
end)
