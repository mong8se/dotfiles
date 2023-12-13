local cmd = vim.cmd
local settings = vim.o
local global = vim.g
local env = vim.env

settings.termguicolors = true

local ColorSchemeGroup = vim.api.nvim_create_augroup('TermBuf', {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    cmd.highlight("Beacon cterm=reverse gui=reverse")
    cmd.highlight("Comment cterm=italic")
  end,
  group = ColorSchemeGroup
})

if env.BASE16_THEME then
  global.base16colorspace = 256
  cmd.colorscheme("base16-" .. env.BASE16_THEME)
else
  if env.IS_DARK_MODE == "1" then
    settings.background = "dark"
    global.gruvbox_material_background = 'soft'
    -- global.gruvbox_material_foreground = 'mix'
    cmd.colorscheme("gruvbox-material")
  else
    settings.background = "light"
    cmd.colorscheme("base16-solarized-light")
  end
end
