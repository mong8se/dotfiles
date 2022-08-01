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

   require("gruvbox").setup({
      undercurl = true,
      underline = true,
      bold = true,
      italic = true,
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "soft", -- can be "hard", "soft" or empty string
      overrides = {},
   })
   cmd("colorscheme gruvbox")
end

cmd("highlight Comment cterm=italic")
