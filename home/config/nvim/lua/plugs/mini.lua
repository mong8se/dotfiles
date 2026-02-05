return {
  {
    "nvim-mini/mini.bracketed",
    opts = {},
  },
  {
    "nvim-mini/mini.comment",
    opts = {},
  },
  {
    "nvim-mini/mini.cursorword",
    opts = {},
  },
  {
    "nvim-mini/mini.starter",
    opts = {},
  },
  {
    "nvim-mini/mini.surround",
    opts = {},
  },
  {
    "nvim-mini/mini.icons",
    opts = {},
    init = function(plugin) require(plugin.name).mock_nvim_web_devicons() end,
  },
  {
    "nvim-mini/mini.clue",
    config = function(plugin)
      local MiniClue = require(plugin.name)
      MiniClue.setup({
        triggers = {
          -- Leader triggers
          {
            mode = "n",
            keys = "<Leader>",
          },
          {
            mode = "x",
            keys = "<Leader>",
          },

          -- Built-in completion
          {
            mode = "i",
            keys = "<C-x>",
          }, -- `g` key
          {
            mode = "n",
            keys = "g",
          },
          {
            mode = "x",
            keys = "g",
          }, -- `[` key
          {
            mode = "n",
            keys = "[",
          },
          {
            mode = "x",
            keys = "[",
          }, -- `]` key
          {
            mode = "n",
            keys = "]",
          },
          {
            mode = "x",
            keys = "]",
          }, -- Marks
          {
            mode = "n",
            keys = "'",
          },
          {
            mode = "n",
            keys = "`",
          },
          {
            mode = "x",
            keys = "'",
          },
          {
            mode = "x",
            keys = "`",
          }, -- Registers
          {
            mode = "n",
            keys = '"',
          },
          {
            mode = "x",
            keys = '"',
          },
          {
            mode = "i",
            keys = "<C-r>",
          },
          {
            mode = "c",
            keys = "<C-r>",
          },

          -- Window commands
          {
            mode = "n",
            keys = "<C-w>",
          }, -- `z` key
          {
            mode = "n",
            keys = "z",
          },
          {
            mode = "x",
            keys = "z",
          },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          MiniClue.gen_clues.builtin_completion(),
          MiniClue.gen_clues.g(),
          MiniClue.gen_clues.marks(),
          MiniClue.gen_clues.registers({
            show_contents = true,
          }),
          MiniClue.gen_clues.square_brackets(),
          MiniClue.gen_clues.windows(),
          MiniClue.gen_clues.z(),
          {
            mode = "n",
            keys = "<Leader>b",
            desc = "+Buffer",
          },
          {
            mode = "n",
            keys = "<Leader>c",
            desc = "+Code",
          },
          {
            mode = "n",
            keys = "<Leader>f",
            desc = "+File",
          },
          {
            mode = "n",
            keys = "<Leader>g",
            desc = "+Git",
          },
          {
            mode = "n",
            keys = "<Leader>h",
            desc = "+Hunk",
          },
          {
            mode = "n",
            keys = "<Leader>p",
            desc = "+Project",
          },
          {
            mode = "n",
            keys = "<Leader>s",
            desc = "+Search",
          },
          {
            mode = "n",
            keys = "<Leader>t",
            desc = "+Toggle",
          },
          {
            mode = "n",
            keys = "<Leader>x",
            desc = "+Diagnostics",
          },
        },
        window = {
          delay = 333,
          config = {
            width = "auto",
            border = "rounded",
          },
        },
      })
    end,
  },
  {
    "nvim-mini/mini.misc",
    init = function(plugin)
      require(plugin.name).setup_auto_root({
        ".bzr",
        ".git",
        ".hg",
        ".svn",
        "Cargo.toml",
        "deno.json",
        "Gemfile",
        "Makefile",
        "package.json",
        "Taskfile",
      })
    end,
    keys = {
      {
        "<leader>bz",
        function()
          require("mini.misc").zoom(0, {
            border = "double",
            height = vim.go.lines - vim.go.cmdheight - 3,
            width = vim.go.columns - 2,
          })
        end,
        silent = true,
        desc = "Zoom a buffer",
      },
    },
  },
  {
    "nvim-mini/mini.map",
    config = function(plugin)
      local MiniMap = require(plugin.name)
      MiniMap.setup({
        integrations = {
          MiniMap.gen_integration.gitsigns(),
        },
        symbols = {
          encode = MiniMap.gen_encode_symbols.dot("4x2"),
          scroll_line = "▐",
          scroll_view = "│",
        },
        window = {
          width = 16,
          winblend = 70,
        },
      })
    end,
    keys = {
      {
        "<leader>tm",
        function() _G.MiniMap.toggle() end,
        desc = "Toggle mini map",
      },
    },
  },
}
