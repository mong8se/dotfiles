local opt = vim.o
local win = vim.wo
local cmd = vim.cmd
local fn = vim.fn
local api = vim.api
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
    if vim.b.gitsigns_head then
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
    local args = opts and opts.fargs or {}

    local lastArg = args[#args]

    if not lastArg or vim.startswith(lastArg, "+") then
        args[#args + 1] = mong8se.directoryFromContext()
    end

    mong8se.smartSplit(unpack(args))
end

local motionCommands = {line = "'[V']", char = "`[v`]", block = "`[\\<c-v>`]"}
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

mong8se.buffers = function()
    local my_name = 'mong8se-buf'
    local handles = {}
    local self = false

    for _, buffer in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
        local name = buffer.name

        if name:sub(-#my_name) == my_name then
            self = buffer
        elseif buffer.loaded then
            if #name > 0 then
                table.insert(handles, buffer)
            end
        end
    end

    if not self then
        self = api.nvim_create_buf(false, true)
        api.nvim_buf_set_name(self, my_name)
    end

    api.nvim_buf_set_option(self, 'buflisted', false)
    api.nvim_buf_set_option(self, 'bufhidden', 'delete')
    api.nvim_buf_set_option(self, 'buftype', 'nofile')
    api.nvim_buf_set_option(self, 'swapfile', false)

    api.nvim_buf_set_keymap(self, 'n', "<CR>", '', {
        callback = function()
            api.nvim_win_set_buf(0, handles[api.nvim_win_get_cursor(0)[1]].bufnr)
        end,
        nowait = true,
        noremap = true,
        silent = true
    })
    api.nvim_buf_set_keymap(self, 'n', "q", '', {
        callback = function()
            api.nvim_buf_delete(self, {})
        end,
        nowait = true,
        noremap = true,
        silent = true
    })

    table.sort(handles, function(a,b)
        return a.lastused > b.lastused
    end)

    local names = {}
    for _, buffer in ipairs(handles) do
        table.insert(names, buffer.name)
    end

    api.nvim_buf_set_lines(self, 0, #names, false, names)
    api.nvim_buf_set_option(self, 'modified', false)
    api.nvim_buf_set_option(self, 'modifiable', false)
    api.nvim_win_set_buf(0, self)
    api.nvim_win_set_cursor(0, { math.min(#names, 2), 0 })
end

-- function! morng8se#ActivateFZF()
--   if exists('b:git_dir')
--     GitFiles
--   else
--     Files
--   endif
-- endfunction

return mong8se
