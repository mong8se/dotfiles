local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('Things', { clear = true })

autocmd(
  { "VimEnter", "WinEnter", "BufWinEnter" },
  { pattern = "*", command = "setlocal cursorline", group = augroup }
)

autocmd(
  "WinLeave",
  { pattern = "*", command = "setlocal nocursorline", group = augroup }
)

--  leave insert or replace mode
autocmd(
  { "BufEnter", "WinLeave", "FocusLost", "VimSuspend" },
  { pattern = "*", command = "if empty(&buftype) | stopinsert | endif", group = augroup }
)

--  Save the buffer if it is modified and has a filename
autocmd(
  { "BufLeave", "FocusLost", "VimSuspend" },
  { pattern = "*", command = "if !empty(@%) | update | endif", group = augroup }
)
