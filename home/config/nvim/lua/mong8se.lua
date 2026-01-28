local opt = vim.opt
local win = vim.wo
local cmd = vim.cmd
local fn = vim.fn
local b = vim.b

local mong8se = {}

-- attempts to load rc files if they exists, silently fails if they don't
-- supports a prefix for a directory name relative to lua folder
mong8se.load_rc_files = function(which)
  local module = which
      and function(name)
        return table.concat({
          which,
          name,
        }, ".")
      end
    or function(name) return name end

  for _, name in pairs({
    "_platform",
    "_machine",
    "local",
  }) do
    pcall(require, module(name))
  end
end

-- require a module or complain it didn't load
mong8se.require_or_complain = function(...)
  for _, name in ipairs({
    ...,
  }) do
    local status, result = pcall(require, name)

    if not status then
      vim.notify_once(string.format("Failed to load %s: %s", name, result))
    end
  end
end

-- toggle line numbers
mong8se.toggle_number_mode = function()
  if opt.relativenumber:get() then
    win.number = false
    win.relativenumber = false
    win.colorcolumn = "0"
  elseif opt.number:get() then
    win.relativenumber = true
    win.colorcolumn = "80"
  else
    win.number = true
    win.colorcolumn = "80"
  end
end

-- scroll bind all windows, works best with vertical splits
mong8se.toggle_scrollbind_all_windows = function()
  if vim.wo.scrollbind then
    cmd("windo setlocal noscrollbind")
  else
    cmd("windo setlocal scrollbind")
    cmd("syncbind")
  end
end

mong8se.pick_git_or_files = function(git_picker, files_picker)
  if b.gitsigns_head then
    git_picker()
  else
    files_picker()
  end
end

mong8se.directory_from_context = function()
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
mong8se.smart_split = function(...)
  local split = "split"

  if fn.winwidth(0) > fn.winheight(0) * 2 then split = "vsplit" end

  cmd(table.concat({
    split,
    ...,
  }, " "))
end

-- Command that uses smart split and by default opens the current directory
-- instead of default behavior of repeating same buffer
mong8se.split_command = function(opts)
  local args = opts and opts.fargs or {}

  local lastArg = args[#args]

  if not lastArg or vim.startswith(lastArg, "+") then
    args[#args + 1] = mong8se.directory_from_context()
  end

  mong8se.smart_split(unpack(args))
end

mong8se.fold_it = function()
  local folded_count = (vim.v.foldend - vim.v.foldstart - 1)

  return string.format(
    "%s %s %s ",
    fn.getline(vim.v.foldstart):gsub(
      "^%s+",
      function(whitespace)
        return string.rep(opt.fillchars:get().fold, #whitespace - 1) .. " "
      end
    ),
    folded_count == 0 and "█ " or ("▌" .. folded_count .. "▐"),
    fn.getline(vim.v.foldend):gsub("^%s*", "")
  )
end

return mong8se
