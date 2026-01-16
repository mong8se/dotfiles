local cmd = vim.cmd
local settings = vim.opt
local env = vim.env

settings.termguicolors = true

local MiniMisc = require("mini.misc")

local ColorSchemeGroup = vim.api.nvim_create_augroup("ColorSchemeGroup", {
  clear = true,
})

local highviz = {
  bold = true,
  bg = "orange",
  fg = "black",
  sp = "lightblue",
}

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    cmd.highlight("Beacon cterm=reverse gui=reverse")
    cmd.highlight("Comment cterm=italic")

    vim.api.nvim_set_hl(0, "MiniJump", highviz)
    vim.api.nvim_set_hl(0, "MiniJump2dSpot", highviz)
    vim.api.nvim_set_hl(0, "MiniJump2dSpotAhead", highviz)
    vim.api.nvim_set_hl(0, "MiniJump2dSpotUnique", highviz)

    MiniMisc.setup_termbg_sync()
  end,
  group = ColorSchemeGroup,
})

settings.background = env.IS_DARK_MODE == "0" and "light" or "dark"

cmd.colorscheme(
  env.BASE16_THEME and ("base16-" .. env.BASE16_THEME) or "gruvbox-material"
)
