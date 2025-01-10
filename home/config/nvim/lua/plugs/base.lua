return {
  'mong8se/actually.nvim',
  -- { dir = '~/Projects/actually.nvim'},

  'mong8se/buffish.nvim',
  -- { dir = '~/Projects/buffish.nvim' },

  {'stevearc/oil.nvim', opts = {}},
  'ibhagwan/fzf-lua',

  {'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },

  'stevearc/dressing.nvim',
  {'rcarriga/nvim-notify',
    config = function() vim.notify = require("notify") end
  },

  'RRethy/nvim-base16',
  'caglartoklu/borlandp.vim',
  'sainnhe/gruvbox-material',
  'danilamihailov/beacon.nvim',

  {'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {indent = {char = "▏"}}
  },

  'roman/golden-ratio', -- C-W \

  {'nvim-lualine/lualine.nvim', opts = {}},
  'airblade/vim-rooter',
  'sheerun/vim-polyglot',

  {'folke/trouble.nvim', opts = {}},
  'dyng/ctrlsf.vim', -- leader /

  'tpope/vim-abolish', -- cr

  {'vimwiki/vimwiki',
    keys = {{'<leader>ww', '<Plug>VimwikiIndex', desc = 'Vimwiki Index'}},
    ft = 'vimwiki'
  },

  {'itchyny/calendar.vim', cmd = 'Calendar'},

  {'mtth/scratch.vim', cmd = 'Scratch'} -- gs
}
