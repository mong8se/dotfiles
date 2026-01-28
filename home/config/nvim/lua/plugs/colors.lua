return {
  {
    "tinted-theming/tinted-nvim",
    config = function()
      require("tinted-colorscheme").with_config({
        supports = { tinty = false, live_reload = false, tinted_shell = true },
      })
    end,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_enable_italic = true
    end,
  },
  "caglartoklu/borlandp.vim",
  { "rose-pine/neovim", name = "rose-pine" },
  { "catppuccin/nvim", name = "catppuccin" },
}
