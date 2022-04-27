local opt = vim.o
local win = vim.wo

local mong8se = {}

mong8se.loadRCFiles = function(which)
  for _, name in pairs({'_platform', '_machine', 'local'}) do
    pcall(require, (table.concat({ which or "", name }, ".")))
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

-- -- scroll bind all windows, works best with vertical splits
-- function! mong8se#ScrollBindAllWindows()
--   if &scrollbind
--     windo setlocal noscrollbind
--   else
--     windo setlocal scrollbind
--     syncbind
--   endif
-- endfunction
-- 
-- -- Telescope
-- function! mong8se#ActivateGitOrFiles()
--   if exists('b:git_dir')
--     Telescope git_files
--   else
--     Telescope find_files
--   endif
-- endfunction
-- 
-- -- fzf
-- function! mong8se#ActivateFZF()
--   if exists('b:git_dir')
--     GitFiles
--   else
--     Files
--   endif
-- endfunction
--

return mong8se
