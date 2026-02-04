local mong8se = require("mong8se")

local setKeyMap = vim.keymap.set

local picker = setmetatable({}, {
  __index = function(_self, key)
    return function(opts) require("fzf-lua")[key](opts) end
  end,
})

-- disable these keys
setKeyMap("n", "<f1>", "<NOP>")
setKeyMap("n", "s", "<NOP>")
setKeyMap("n", "S", "<NOP>")

setKeyMap("n", "<leader> ", require("buffish").open, {
  silent = true,
  desc = "Switch buffer",
})

setKeyMap("n", "<leader>:", picker.commands, {
  desc = "Fuzzy command",
})
setKeyMap("n", "<leader>'", picker.marks, {
  desc = "Fuzzy marks",
})
setKeyMap("n", '<leader>"', picker.registers, {
  desc = "Fuzzy registers",
})

setKeyMap("n", "gV", [['`[' . strpart(getregtype(), 0, 1) . '`]']], {
  expr = true,
  desc = "Switch to VISUAL selecting last pasted text",
})

local clipboard_register =
  string.format('"%s', vim.fn.has("macunix") and "+" or "*")
setKeyMap("n", "gp", clipboard_register .. "]p", {
  desc = "Paste from system",
})
setKeyMap("n", "gP", clipboard_register .. "]P", {
  desc = "Paste from system before",
})

setKeyMap("n", "U", "<C-r>")
setKeyMap("n", "Y", "y$")

setKeyMap(
  "n",
  "<C-L>",
  ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>",
  {
    silent = true,
  }
)
setKeyMap("n", "<Down>", "gj")
setKeyMap("n", "<Up>", "gk")
setKeyMap("n", "<C-k>", "<C-e>gk")
setKeyMap("n", "<C-j>", "<C-y>gj")
setKeyMap("n", "<S-Up>", "v<Up>")
setKeyMap("n", "<S-Down>", "v<Down>")
setKeyMap("n", "<S-Left>", "v<Left>")
setKeyMap("n", "<S-Right>", "v<Right>")
setKeyMap("n", "+", "$e^", {
  desc = "Down to next non blank line",
})
setKeyMap("n", "-", [[:keeppatterns call search("^\\s*\\S", "be")<cr>]], {
  desc = "Up to previous non blank line",
})

setKeyMap("n", "go", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>", {
  silent = true,
  desc = "Blank line below",
})

setKeyMap("n", "gO", ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[", {
  silent = true,
  desc = "Blank line above",
})

setKeyMap("v", "<S-Up>", "<Up>")
setKeyMap("v", "<S-Down>", "<Down>")
setKeyMap("v", "<S-Left>", "<Left>")
setKeyMap("v", "<S-Right>", "<Right>")
setKeyMap("v", "<C-j>", ":m '>+1<CR>gv=gv", {
  desc = "Move selection down",
})
setKeyMap("v", "<C-k>", ":m '<-2<CR>gv=gv", {
  desc = "Move selection up",
})
setKeyMap("v", "<", "<gv")
setKeyMap("v", ">", ">gv")

-- buffer
setKeyMap("n", "<leader>bb", picker.buffers, {
  silent = true,
  desc = "List",
})
setKeyMap("n", "<leader>bd", function()
  local lastBuf = vim.api.nvim_win_get_buf(0)
  vim.cmd("edit " .. mong8se.directory_from_context())
  vim.schedule(function() vim.api.nvim_buf_delete(lastBuf, {}) end)
end, {
  silent = true,
  desc = "Delete current buffer",
})
setKeyMap("n", "<leader>bs", picker.lsp_document_symbols, {
  silent = true,
  desc = "Symbols",
})
setKeyMap("n", "<leader>bx", picker.diagnostics_document, {
  silent = true,
  desc = "Diagnostics",
})
setKeyMap("n", "<leader>;", require("buffish.shortcuts").follow, {
  desc = "Go to Buffish shortcut",
})

-- file
setKeyMap(
  "n",
  "<leader>f-",
  function() vim.cmd("edit " .. mong8se.directory_from_context()) end,
  {
    silent = true,
    desc = "Browse files from here",
  }
)
setKeyMap("n", "<leader>ff", function() vim.cmd("edit .") end, {
  silent = true,
  desc = "Browse files from root",
})

setKeyMap("n", "<leader>fz", picker.files, {
  desc = "Search for file",
})

setKeyMap(
  "n",
  "<leader>fc",
  function() picker.files({ cwd = vim.fn.stdpath("config") }) end,
  { desc = "Find Config File" }
)

-- toggle
setKeyMap("n", "<leader>tn", mong8se.toggle_number_mode, {
  silent = true,
  desc = "Toggle numbers",
})
setKeyMap("n", "<leader>tb", mong8se.toggle_scrollbind_all_windows, {
  silent = true,
  desc = "Toggle scroll bind",
})
setKeyMap("n", "<leader>tc", picker.colorschemes, {
  silent = true,
  desc = "Toggle colorscheme",
})
setKeyMap("n", "<leader>ts", "<cmd>setlocal spell!<CR><cmd>set spell?<CR>", {
  silent = true,
  desc = "Toggle spell check",
})
setKeyMap("n", "<leader>tw", "<cmd>setlocal wrap!<CR><cmd>set wrap?<CR>", {
  silent = true,
  desc = "Toggle line wrap",
})
setKeyMap("n", "<leader>tp", "<cmd>setlocal paste!<CR><cmd>set paste?<CR>", {
  silent = true,
  desc = "Toggle paste",
})
setKeyMap("n", "<leader>ti", "<cmd>IBLToggle<CR>", {
  desc = "Toggle indent blanklines",
})

-- project
setKeyMap(
  "n",
  "<leader>pp",
  function() mong8se.pick_git_or_files(picker.git_files, picker.files) end,
  {
    silent = true,
    desc = "Find project files",
  }
)
setKeyMap("n", "<leader>ps", picker.lsp_workspace_symbols, {
  silent = true,
  desc = "Symbols",
})
setKeyMap("n", "<leader>px", picker.diagnostics_workspace, {
  silent = true,
  desc = "Diagnostics",
})
setKeyMap("n", "<leader>p/", picker.live_grep, {
  silent = true,
  desc = "Search in project",
})

-- git
setKeyMap("n", "<leader>gg", picker.git_status, {
  silent = true,
  desc = "Git status",
})
setKeyMap("n", "<leader>gl", picker.git_commits, {
  silent = true,
  desc = "Git log",
})
setKeyMap("n", "<leader>gc", picker.git_bcommits, {
  silent = true,
  desc = "Git log for buffer",
})
setKeyMap("n", "<leader>gb", picker.git_branches, {
  silent = true,
  desc = "Git branches",
})
setKeyMap("n", "<leader>gs", picker.git_stash, {
  silent = true,
  desc = "Git stash",
})

-- search
setKeyMap("n", "<leader>sh", picker.search_history, {
  desc = "Search history",
})
setKeyMap("n", "<leader>sp", picker.live_grep, {
  desc = "Search all lines in project",
})

-- diagnostics
setKeyMap("n", "<leader>xx", picker.diagnostics_workspace, {
  silent = true,
  desc = "Diagnostics",
})
setKeyMap("n", "<leader>xb", picker.diagnostics_document, {
  silent = true,
  desc = "Current Buffer",
})

-- window
setKeyMap("n", "<c-w>s", mong8se.split_command, {
  silent = true,
  desc = "Split and browse",
})
setKeyMap("n", "<c-w><C-s>", mong8se.split_command, {
  desc = "Split and browse",
  silent = true,
})
setKeyMap("t", "<c-w><C-w>", "<C-\\><C-n>")

-- Insert mode
setKeyMap("i", "<C-a>", "<C-o>^")
setKeyMap("i", "<C-e>", "<C-o>$")
setKeyMap("i", "<C-k>", "<C-o>C")

-- Command mode
setKeyMap("c", "<C-a>", "<Home>")
setKeyMap("c", "<C-e>", "<End>")
