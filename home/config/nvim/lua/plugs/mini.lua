return {
  {
    'echasnovski/mini.nvim',
    dependencies = 'lewis6991/gitsigns.nvim',
    config = function()
      require('mini.bracketed').setup()
      require('mini.comment').setup()
      require('mini.cursorword').setup()
      require('mini.jump').setup()
      require('mini.pairs').setup()
      require('mini.starter').setup()

      require('mini.surround').setup()

      local MiniIcons = require('mini.icons')
      MiniIcons.setup()
      MiniIcons.mock_nvim_web_devicons()

      local jump2d = require('mini.jump2d')
      local jump_line_start = jump2d.builtin_opts.word_start
      jump2d.setup({spotter = jump_line_start.spotter})

      local MiniMap = require('mini.map')
      MiniMap.setup({
        integrations = {MiniMap.gen_integration.gitsigns()},
        symbols = {
          encode = MiniMap.gen_encode_symbols.dot("4x2"),
          scroll_line = '▐',
          scroll_view = '│'
        },
        window = {width = 16, winblend = 70}
      })
    end
  }
}
