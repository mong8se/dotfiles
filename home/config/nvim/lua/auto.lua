local autocmd = vim.api.nvim_create_autocmd
local CursorLine = vim.api.nvim_create_augroup("CursorLine", { clear = true })
local ScrollOff = vim.api.nvim_create_augroup("CursorLine", { clear = true })
local FocusIssues = vim.api.nvim_create_augroup("FocusIssues", { clear = true })
local YankSync = vim.api.nvim_create_augroup("YankSync", { clear = true })
local TermBuf = vim.api.nvim_create_augroup("TermBuf", { clear = true })

-- cursorline only for active window
autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = function() vim.wo.cursorline = true end,
  group = CursorLine,
})

autocmd("WinLeave", {
  pattern = "*",
  callback = function() vim.wo.cursorline = false end,
  group = CursorLine,
})

autocmd("InsertEnter", {
  pattern = "*",
  callback = function() vim.cmd.highlight("CursorLine", "gui=underline") end,
  group = CursorLine,
})

autocmd("InsertLeave", {
  pattern = "*",
  callback = function() vim.cmd.highlight("CursorLine", "gui=none") end,
  group = CursorLine,
})

--  leave insert or replace mode
autocmd({ "BufEnter", "WinLeave", "FocusLost", "VimSuspend" }, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" then vim.cmd.stopinsert() end
  end,
  group = FocusIssues,
})

--  Save the buffer if it is modified and has a filename
autocmd({ "BufLeave", "FocusLost", "VimSuspend" }, {
  pattern = "*",
  callback = function()
    vim.schedule(function() vim.cmd.nohlsearch() end)
    if vim.bo.buftype == "" and vim.fn.getreg("%") ~= "" then
      vim.cmd.update()
    end
  end,
  group = FocusIssues,
})

autocmd({ "WinResized", "VimEnter" }, {
  pattern = "*",
  callback = function(details)
    if details.event == "WinResized" then
      if vim.fn.win_gettype(details.match) == "" then
        for _, win in ipairs(vim.v.event.windows) do
          vim.wo[win].scrolloff = math.floor(vim.fn.winheight(win) / 10)
        end
      end
    else
      if vim.fn.win_gettype() == "" then
        vim.wo.scrolloff = math.floor(vim.fn.winheight(0) / 10)
      end
    end
  end,
  group = ScrollOff,
})

-- make gq in normal mode in a help file close the help
-- similar to what happens in fugitive
autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.keymap.set(
      "n",
      "gq",
      ":helpclose<CR>",
      { remap = true, silent = true, buffer = true }
    )
  end,
})

-- whenever we yank to the unamed register also copy to the + and * registers
-- instead of using the clipboard=unamed setting which does so even on deletes
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      for _, reg in ipairs({ "*", "+" }) do
        vim.fn.setreg(reg, vim.v.event.regcontents, vim.v.event.regtype)
      end
    end
  end,
  group = YankSync,
})

-- automatically enter insert mode when you open or enter a terminal
autocmd({ "BufEnter", "TermOpen" }, {
  pattern = "*",
  callback = function(details)
    if details.event == "BufEnter" and vim.bo.buftype ~= "terminal" then
      return
    end

    vim.cmd.startinsert()
  end,
  group = TermBuf,
})
