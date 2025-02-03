return {
  'mong8se/actually.nvim',
  -- {dir = '~/Work/actually.nvim'},

  'mong8se/buffish.nvim',
  -- {dir = '~/Work/buffish.nvim'},

  'ibhagwan/fzf-lua',

  {
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = {method = 'popup'}
    end
  },

  'stevearc/dressing.nvim',
  {
    'rcarriga/nvim-notify',
    config = function() vim.notify = require("notify") end
  },

  'RRethy/nvim-base16',
  'caglartoklu/borlandp.vim',
  'sainnhe/gruvbox-material',
  'danilamihailov/beacon.nvim',

  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {indent = {char = "▏"}}
  },

  'roman/golden-ratio', -- C-W \
  {'nvim-lualine/lualine.nvim', opts = {}},
  'airblade/vim-rooter',
  'sheerun/vim-polyglot',

  {
    'MagicDuck/grug-far.nvim',
    opts = {engines = {ripgrep = {extraArgs = "--context 2"}}},

    keys = {
      {
        '<leader>/',
        function() require('grug-far').open() end,
        desc = 'Search and replace'
      }
    }
  },

  {
    'vimwiki/vimwiki',
    ft = 'vimwiki',
    keys = {{'<leader>ww', '<Plug>VimwikiIndex', desc = 'Vimwiki Index'}}
  },

  'tpope/vim-abolish', -- cr

  {'itchyny/calendar.vim', cmd = 'Calendar'},

  {'mtth/scratch.vim', cmd = 'Scratch'} -- gs
}
