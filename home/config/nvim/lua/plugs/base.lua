return {
  'mong8se/actually.nvim',
  -- { dir = '~/Projects/actually.nvim'},
  'mong8se/buffish.nvim',
  -- { dir = '~/Projects/buffish.nvim' },

  'ibhagwan/fzf-lua',
  'stevearc/dressing.nvim',
  'rcarriga/nvim-notify',

  'RRethy/nvim-base16',
  'caglartoklu/borlandp.vim',
  'sainnhe/gruvbox-material',

  'lukas-reineke/indent-blankline.nvim',
  'folke/trouble.nvim',

  'roman/golden-ratio', -- C-W \
  'danilamihailov/beacon.nvim',

  'echasnovski/mini.nvim',

  'nvim-lualine/lualine.nvim',

  'airblade/vim-rooter',
  'lewis6991/gitsigns.nvim',
  'sheerun/vim-polyglot',

  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdateSync'},
  'nvim-treesitter/nvim-treesitter-textobjects',

  'dyng/ctrlsf.vim', -- leader /

  'neovim/nvim-lspconfig',

  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      'hrsh7th/cmp-cmdline',
      -- For vsnip users.
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
    },
  },

  'tpope/vim-abolish', -- cr

  'stevearc/oil.nvim',

  'vimwiki/vimwiki',
  {'itchyny/calendar.vim', cmd = 'Calendar'},
  {'mtth/scratch.vim', cmd = 'Scratch'}, -- gs
}
