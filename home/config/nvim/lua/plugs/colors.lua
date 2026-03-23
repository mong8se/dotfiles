return {
  {
    "tinted-theming/tinted-nvim",
    opts = {},
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
  { "kungfusheep/mfd.nvim" },
}
