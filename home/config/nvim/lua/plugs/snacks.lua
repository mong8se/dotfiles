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
      input = {},
      scope = {},
      styles = {
        notification_history = {
          width = 100,
        },
      },
    },
    init = function()
      if vim.fn.has("user_commands") then
        vim.api.nvim_create_user_command(
          "Notifications",
          function() require("snacks.notifier").show_history() end,
          {}
        )
      end
    end,
  },
}
