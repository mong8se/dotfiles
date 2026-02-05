return {
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      engines = {
        ripgrep = {
          extraArgs = "--context 2",
        },
      },
    },
    keys = {
      {
        "<leader>/",
        function() require("grug-far").open() end,
        desc = "Search and replace",
      },
      {
        "<leader>*",
        mode = "n",
        function()
          require("grug-far").open({
            prefills = { search = vim.fn.expand("<cword>") },
            startInInsertMode = false,
            transient = true,
          })
        end,
        {
          desc = "Search current word",
        },
      },
      {
        "<leader>*",
        mode = { "x", "v" },
        function()
          require("grug-far").open({
            startInInsertMode = false,
            transient = true,
          })
        end,
        {
          desc = "Search current word",
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          highlight = { backdrop = true },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
