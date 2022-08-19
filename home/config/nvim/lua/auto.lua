local autocmd = vim.api.nvim_create_autocmd
local CursorLine = vim.api.nvim_create_augroup('CursorLine', {clear = true})
local FocusIssues = vim.api.nvim_create_augroup('FocusIssues', {clear = true})
local YankSync = vim.api.nvim_create_augroup('YankSync', {clear = true})
local QuickScope = vim.api.nvim_create_augroup('QuickScope', {clear = true})

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
    callback = function()
        if vim.bo.buftype == "" then vim.cmd("stopinsert") end
    end,
    group = FocusIssues
})

--  Save the buffer if it is modified and has a filename
autocmd({"BufLeave", "FocusLost", "VimSuspend"}, {
    pattern = "*",
    callback = function()
        if vim.fn.getreg("%") ~= "" then vim.cmd("update") end
    end,
    group = FocusIssues
})

-- gq in normal mode in a help file closes the help
-- similar to what happens in fugitive
autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.keymap.set('n', 'gq', ':helpclose<CR>',
                       {remap = true, silent = true, buffer = true})
    end
})

autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then
            vim.fn.setreg("+", table.concat(vim.v.event.regcontents, "\n"))
        end
    end,
    group = YankSync
})

autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = 'yellow', underline = true } )
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = 'orange',  underline = true } )
    end,
    group = QuickScope
})
