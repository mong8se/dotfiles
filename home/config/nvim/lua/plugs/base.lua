return {
  'mong8se/actually.nvim',
  -- { dir = '~/Projects/actually.nvim'},

  'mong8se/buffish.nvim',
  -- { dir = '~/Projects/buffish.nvim' },

  {'stevearc/oil.nvim', opts = {}},
  'ibhagwan/fzf-lua',

  'stevearc/dressing.nvim', {
    'rcarriga/nvim-notify',
    config = function() vim.notify = require("notify") end
  },

  'RRethy/nvim-base16',
  'caglartoklu/borlandp.vim',
  'sainnhe/gruvbox-material',

  {'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {indent = {char = "▏"}}
  },

  {'folke/trouble.nvim', opts = {}},
  'roman/golden-ratio', -- C-W \
  'danilamihailov/beacon.nvim',

  {'nvim-lualine/lualine.nvim', opts = {}},
  'airblade/vim-rooter',
  'sheerun/vim-polyglot',

  'dyng/ctrlsf.vim', -- leader /

  'tpope/vim-abolish', -- cr

  {'vimwiki/vimwiki',
    keys = {{'<leader>ww', '<Plug>VimwikiIndex', desc = 'Vimwiki Index'}},
    ft = 'vimwiki'
  },

  {'itchyny/calendar.vim', cmd = 'Calendar'},

  {'mtth/scratch.vim', cmd = 'Scratch'} -- gs
}
