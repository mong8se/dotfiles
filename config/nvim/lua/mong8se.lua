local opt = vim.o
local win = vim.wo

local mong8se = {}

mong8se.loadRCFiles = function(which)
    local module = which and
                       function(name)
            return table.concat({which, name}, ".")
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
        win.colorcolumn = "0"
    elseif opt.number then
        win.relativenumber = true
        win.colorcolumn = "80"
    else
        win.number = true
        win.colorcolumn = "80"
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

mong8se.directoryFromContext = function()
    local filename = vim.fn.getreg("%")

    if filename == "" then
        return "."
    elseif vim.fn.isdirectory(filename) == 1 then
        return "%"
    else
        return "%:h"
    end
end

-- Split either horizontal or vertical, whichever is bigger, arguments
-- are passed to vim's split command
mong8se.smartSplit = function(...)
    local cmd = "split"

    if vim.fn.winwidth(0) > vim.fn.winheight(0) * 2 then cmd = "vsplit" end

    vim.cmd(table.concat({cmd, ...}, " "))
end

-- Command that uses smart split and by default opens the current directory
-- instead of default behavior of repeating same buffer
local function splitCommand(opts)
    local args = opts.fargs

    local lastArg = args[#args]

    if not lastArg or vim.startswith(lastArg, "+") then
        args[#args + 1] = mong8se.directoryFromContext()
    end

    mong8se.smartSplit(unpack(args))
end

vim.api.nvim_create_user_command("Split", splitCommand, {nargs = "*"})
vim.api.nvim_create_user_command("SPlit", splitCommand, {nargs = "*"})

-- function! morng8se#ActivateFZF()
--   if exists('b:git_dir')
--     GitFiles
--   else
--     Files
--   endif
-- endfunction

return mong8se
