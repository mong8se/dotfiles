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

    if (not args[#args]) or vim.startswith(args[#args], "+") then
        table.insert(args,
                     (vim.fn.isdirectory(vim.fn.expand("%")) == 1) and "%" or
                         "%:h")
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
