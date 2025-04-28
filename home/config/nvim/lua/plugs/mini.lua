return {
  {
    "echasnovski/mini.nvim",
    dependencies = "lewis6991/gitsigns.nvim",
    config = function()
      require("mini.bracketed").setup()
      require("mini.comment").setup()
      require("mini.cursorword").setup()
      require("mini.jump").setup()
      require("mini.pairs").setup()
      require("mini.starter").setup()

      require("mini.surround").setup()

      local MiniIcons = require("mini.icons")
      MiniIcons.setup()
      MiniIcons.mock_nvim_web_devicons()

      local MiniJump2d = require("mini.jump2d")
      MiniJump2d.setup({
        spotter = MiniJump2d.builtin_opts.line_start.spotter,
        labels = "1234qwerasdfzxcv5678tyuighjkbnm,90-=op[]l;'./",
        hooks = {
          after_jump = function()
            MiniJump2d.start({
              spotter = MiniJump2d.builtin_opts.default.spotter,
              allowed_lines = {
                cursor_before = false,
                cursor_after = false,
              },
              allowed_windows = {
                not_current = false,
              },
              -- hl_group = 'Search',
              hooks = {
                after_jump = function() end,
              },
            })
          end,
        },
      })

      local MiniMap = require("mini.map")
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
  },
}
