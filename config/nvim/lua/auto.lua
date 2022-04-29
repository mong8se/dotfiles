local autocmd = vim.api.nvim_create_autocmd
local CursorLine = vim.api.nvim_create_augroup('CursorLine', {clear = true})
local FocusIssues = vim.api.nvim_create_augroup('FocusIssues', {clear = true})

-- cursorline only for active window
autocmd({"VimEnter", "WinEnter", "BufWinEnter"}, {
    pattern = "*",
    callback = function() vim.wo.cursorline = true end,
    group = CursorLine
})

autocmd("WinLeave", {
    pattern = "*",
    callback = function() vim.wo.cursorline = false end,
    group = CursorLine
})

--  leave insert or replace mode
autocmd({"BufEnter", "WinLeave", "FocusLost", "VimSuspend"}, {
    pattern = "*",
    command = "if empty(&buftype) | stopinsert | endif",
    group = FocusIssues
})

--  Save the buffer if it is modified and has a filename
autocmd({"BufLeave", "FocusLost", "VimSuspend"}, {
    pattern = "*",
    command = "if !empty(@%) | update | endif",
    group = FocusIssues
})

-- gq in normal mode in a help file closes the help
-- similar to what happens in fugitive
autocmd("FileType", {
    pattern = "help",
    command = "nmap <silent> <buffer> gq :helpclose<CR>"
})
