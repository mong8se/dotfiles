return {
  "mong8se/actually.nvim",
  -- {dir = '~/Work/actually.nvim'},

  "mong8se/buffish.nvim",
  -- {dir = '~/Work/buffish.nvim'},

  {
    "ibhagwan/fzf-lua",
    opts = { "ivy" },
    init = function(plugin) require(plugin.name).register_ui_select() end,
  },

  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
      }
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      top_down = false,
      render = "wrapped-compact",
    },
    init = function() vim.notify = require("notify") end,
  },

  "danilamihailov/beacon.nvim",

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = {
          "▏",
          "▎",
          "▍",
          "▌",
          "▋",
          "▊",
          "▉",
          "█",
        },
      },
    },
  },

  {
    "roman/golden-ratio", -- C-W \
    init = function() vim.g.golden_ratio_autocommand = 0 end,
    keys = {
      {
        "<leader>tr",
        "<Plug>(golden_ratio_toggle)",
        desc = "Toggle golden ratio",
      },
      {
        "<c-w>\\",
        "<Plug>(golden_ratio_resize)",
        desc = "Toggle golden ratio",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {},
  },

  "airblade/vim-rooter",

  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/OneDrive - dpz/Documents/vimwiki/",
          auto_diary_index = 1,
        },
      }
    end,
    ft = "vimwiki",
    keys = {
      {
        "<leader>ww",
        "<Plug>VimwikiIndex",
        desc = "Vimwiki Index",
      },
    },
  },

  "tpope/vim-abolish", -- cr

  {
    "itchyny/calendar.vim",
    cmd = "Calendar",
  },

  {
    "mtth/scratch.vim",
    cmd = "Scratch",
  }, -- gs
}
