return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      indent = {
        indent = {
          char = "▏",
        },
        scope = {
          char = "▏",
          hl = "Normal",
        },
        animate = {
          enabled = false,
        },
      },
      notifier = {
        style = "fancy",
      },
      -- picker = {
      -- },
      input = {
      }
    },
  },
}
