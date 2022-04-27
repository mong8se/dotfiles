local opt = vim.o
local win = vim.wo

local mong8se = {}

mong8se.loadRCFiles = function(which)
  local module = which and function(name)
    return table.concat({ which, name }, ".")
  end or function(name) return name end

  for _, name in pairs({'_platform', '_machine', 'local'}) do
    pcall(require, module(name))
  end
end

-- toggle line numbers
mong8se.toggleNumberMode = function()
  if opt.relativenumber then
    win.number = false
    win.relativenumber = false
    win.colorcolumn="0"
  elseif opt.number then
    win.relativenumber = true
    win.colorcolumn="80"
  else
    win.number = true
    win.colorcolumn="80"
  end
end

-- scroll bind all windows, works best with vertical splits
mong8se.toggleScrollBindAllWindows = function()
  if vim.wo.scrollbind then
      vim.cmd("windo setlocal noscrollbind")
  else
      vim.cmd("windo setlocal scrollbind")
      vim.cmd("syncbind")
  end
end

-- Telescope
mong8se.activateGitOrFiles = function()
  local telescope = require("telescope.builtin")
  if vim.b.git_dir then
    telescope.git_files()
  else
    telescope.find_files()
  end
end

-- function! mong8se#ActivateFZF()
--   if exists('b:git_dir')
--     GitFiles
--   else
--     Files
--   endif
-- endfunction

return mong8se
