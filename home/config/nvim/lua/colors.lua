local cmd = vim.cmd
local settings = vim.o
local global = vim.g
local env = vim.env

settings.termguicolors = true

local MiniMisc = require('mini.misc')

local ColorSchemeGroup = vim.api.nvim_create_augroup('ColorSchemeGroup',
                                                     {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    cmd.highlight("Beacon cterm=reverse gui=reverse")
    cmd.highlight("Comment cterm=italic")
    MiniMisc.setup_termbg_sync()
  end,
  group = ColorSchemeGroup
})

if env.BASE16_THEME then
  global.base16colorspace = 256
  cmd.colorscheme("base16-" .. env.BASE16_THEME)
else
  cmd.colorscheme("gruvbox-material")
  global.gruvbox_material_background = 'soft'
  -- global.gruvbox_material_foreground = 'mix'
  if env.IS_DARK_MODE == "1" then
    settings.background = "dark"
  else
    settings.background = "light"
  end
end
