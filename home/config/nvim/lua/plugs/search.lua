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
}
