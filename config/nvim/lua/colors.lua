local cmd = vim.cmd
local settings = vim.o
local global = vim.g
local env = vim.env

settings.termguicolors = true

if env.BASE16_THEME then
   global.base16colorspace = 256
   cmd("colorscheme base16-" .. env.BASE16_THEME)
else
   if env.TERM_PROGRAM == "iTerm" and env.ITERM_PROFILE == "light" then
      settings.background = "light"
   else
      settings.background = "dark"
   end
  global.gruvbox_italic=1
  global.gruvbox_contrast_dark="soft"
  global.gruvbox_contrast_light="hard"
  global.gruvbox_invert_selection=0
  global.gruvbox_hls_cursor="fg0"

  cmd("colorscheme gruvbox-flat")
end

cmd("highlight Comment cterm=italic")
