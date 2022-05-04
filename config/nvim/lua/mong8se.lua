local opt = vim.o
local win = vim.wo
local cmd = vim.cmd
local fn = vim.fn

local mong8se = {}

-- attempt to load rc files if they exists
-- silently fail if they don't
-- supports a prefix for a directory name
-- relative to lua folder
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
        cmd("windo setlocal noscrollbind")
    else
        cmd("windo setlocal scrollbind")
        cmd("syncbind")
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
    local filename = fn.getreg("%")

    if filename == "" then
        return "."
    elseif fn.isdirectory(filename) == 1 then
        return "%"
    else
        return "%:h"
    end
end

-- Split either horizontal or vertical, whichever is bigger, arguments
-- are passed to vim's split command
mong8se.smartSplit = function(...)
    local split = "split"

    if fn.winwidth(0) > fn.winheight(0) * 2 then split = "vsplit" end

    cmd(table.concat({split, ...}, " "))
end

-- Command that uses smart split and by default opens the current directory
-- instead of default behavior of repeating same buffer
mong8se.splitCommand = function(opts)
    local args = opts.fargs

    local lastArg = args[#args]

    if not lastArg or vim.startswith(lastArg, "+") then
        args[#args + 1] = mong8se.directoryFromContext()
    end

    mong8se.smartSplit(unpack(args))
end


local motionCommands = {line= "'[V']", char= "`[v`]", block= "`[\\<c-v>`]"}
mong8se.visualToSearch = function(mode)
    if type(mode) ~= "string" then
        vim.go.operatorfunc = "v:lua.require'mong8se'.visualToSearch"
        return 'g@'
    end

    -- TODO: "block" mode doesn't work right or make sense
    local originalValue = fn.getreginfo("s")
    cmd('silent noautocmd keepjumps normal! ' .. motionCommands[mode] .. '"sy')
    fn.setreg("/",
              [[\V]] .. fn.getreg("s"):gsub([[\]], [[\\]]):gsub('\n', [[\n]]))
    fn.setreg("s", originalValue)
end

-- function! morng8se#ActivateFZF()
--   if exists('b:git_dir')
--     GitFiles
--   else
--     Files
--   endif
-- endfunction

return mong8se
