local cmd = vim.cmd
local settings = vim.o
local global = vim.g
local env = vim.env

settings.termguicolors = true

if env.BASE16_THEME then
   global.base16colorspace = 256
   cmd("colorscheme base16-" .. env.BASE16_THEME)
else
     vim.fn.system("isDarkMode");
     if vim.v.shell_error == 0 then
        settings.background = "dark"
     else
        settings.background = "light"
     end

     global.gruvbox_material_background = 'soft'
     -- global.gruvbox_material_foreground = 'mix'
     cmd("colorscheme gruvbox-material")
end

cmd("highlight Comment cterm=italic")
