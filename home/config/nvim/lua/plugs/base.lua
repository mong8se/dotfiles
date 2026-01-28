return {
  "mong8se/actually.nvim",
  -- {dir = '~/Work/actually.nvim'},

  "mong8se/buffish.nvim",
  -- { dir = "~/Work/buffish.nvim" },

  {
    "ibhagwan/fzf-lua",
    opts = { "default" },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  { "danilamihailov/beacon.nvim", opts = { speed = 1 } },

  {
    "roman/golden-ratio", -- C-W \
    init = function() vim.g.golden_ratio_autocommand = 0 end,
    keys = {
      {
        "<leader>tr",
        "<Plug>(golden_ratio_toggle)",
        desc = "Toggle golden ratio",
        silent = true,
      },
      {
        "<c-w>\\",
        "<Plug>(golden_ratio_resize)",
        desc = "Toggle golden ratio",
        silent = true,
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {},
  },

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
