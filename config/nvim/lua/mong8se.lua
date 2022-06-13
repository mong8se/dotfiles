local opt = vim.o
local win = vim.wo
local cmd = vim.cmd
local fn = vim.fn
local api = vim.api
local b = vim.b
local pretty_print = vim.pretty_print

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
    if b.gitsigns_head then
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
    local self = api.nvim_create_buf(false, true)
    local ns = api.nvim_create_namespace("mong8se-buf")

    api.nvim_buf_set_option(self, 'buflisted', false)
    api.nvim_buf_set_option(self, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(self, 'buftype', 'nofile')
    api.nvim_buf_set_option(self, 'swapfile', false)

    api.nvim_buf_set_keymap(self, 'n', "q", '', {
        callback = function()
            api.nvim_buf_delete(self, {})
        end,
        nowait = true,
        noremap = true,
        silent = true
    })

    render_buffers(self, ns)

    api.nvim_win_set_buf(0, self)
    cmd([[syntax match Conceal #^.\+$# conceal]])
    safely_set_cursor(self, 2)
end

function selected_buffer(handles)
    return handles[api.nvim_win_get_cursor(0)[1]].bufnr
end

function safely_set_cursor(self, loc)
    api.nvim_win_set_cursor(0, { math.min(api.nvim_buf_line_count(self), loc), 0 })
end

function render_buffers(self, ns)
    local handles = {}
    local names = {}

    local old_conceallevel = win.conceallevel
    win.conceallevel = 1
    local old_concealcursor = win.concealcursor
    win.concealcursor = "n"

    local autocmd = vim.api.nvim_create_autocmd
    local Mong8seBuffer = vim.api.nvim_create_augroup('Mong8seBuffer'..self, {clear = true})
    autocmd("BufWinLeave", {
        buffer = self,
        callback = function()
            win.conceallevel = old_conceallevel
            win.concealcursor = old_concealcursor
        end,
        group = Mong8seBuffer
    })

    for _, buffer in ipairs(fn.getbufinfo({buflisted = 1})) do
        local name = buffer.name

        if #name > 0 then
            table.insert(handles, buffer)

            local parts = vim.split(buffer.name, "/")
            local filename = parts[#parts]

            names[filename] = names[filename]==nil and 1 or names[filename] + 1
        else
            pretty_print("no name")
        end
    end

    table.sort(handles, function(a,b)
        if a.lastused == b.lastused then
            return a.bufnr > b.bufnr
        else
            return a.lastused > b.lastused
        end
    end)

    api.nvim_buf_set_option(self, 'modifiable', true)
    api.nvim_buf_set_lines(self, 0, -1, false, {})

    for i, buffer in ipairs(handles) do
        local parts = vim.split(buffer.name, "/")
        local filename = parts[#parts]

        local add_prefix = names[filename] > 1

        api.nvim_buf_set_lines(self, i-1, i, false, { buffer.name })

        if add_prefix then
            api.nvim_buf_set_extmark(self, ns, i-1, 0, {virt_text_win_col=0, virt_text={{parts[#parts-1].."/", "Directory"}}})
        end
        api.nvim_buf_set_extmark(self, ns, i-1, 1,
            {virt_text_win_col=add_prefix and #parts[#parts-1]+1 or 0, virt_text={{filename, "Identifier"}}})
    end

    api.nvim_buf_set_option(self, 'modified', false)
    api.nvim_buf_set_option(self, 'modifiable', false)

    api.nvim_buf_set_keymap(self, 'n', "<CR>", '', {
        callback = function()
            api.nvim_win_set_buf(0, selected_buffer(handles))
        end,
        nowait = true,
        noremap = true,
        silent = true
    })

    api.nvim_buf_set_keymap(self, 'n', "dd", '', {
        callback = function()
            local old_line = api.nvim_win_get_cursor(0)[1]
            api.nvim_buf_delete(selected_buffer(handles), {})
            render_buffers(self, ns)
            safely_set_cursor(self, old_line)
        end,
        nowait = true,
        noremap = true,
        silent = true
    })
end

-- function! morng8se#ActivateFZF()
--   if exists('b:git_dir')
--     GitFiles
--   else
--     Files
--   endif
-- endfunction

return mong8se
