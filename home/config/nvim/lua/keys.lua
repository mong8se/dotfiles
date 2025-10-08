local mong8se = require("mong8se")

local setKeyMap = vim.keymap.set

local fzf = require("fzf-lua")

-- disable these keys
setKeyMap("n", "<f1>", "<NOP>")
setKeyMap("n", "s", "<NOP>")
setKeyMap("n", "S", "<NOP>")

setKeyMap("n", "<leader> ", require("buffish").open, {
  silent = true,
  desc = "Switch buffer",
})

setKeyMap("n", "<leader>:", fzf.commands, {
  desc = "Fuzzy command",
})
setKeyMap("n", "<leader>'", fzf.marks, {
  desc = "Fuzzy marks",
})
setKeyMap("n", '<leader>"', fzf.registers, {
  desc = "Fuzzy registers",
})

setKeyMap("n", "gV", [['`[' . strpart(getregtype(), 0, 1) . '`]']], {
  expr = true,
  desc = "Switch to VISUAL selecting last pasted text",
})

local clipboard = vim.fn.has("macunix") and "+" or "*"
setKeyMap("n", "gp", '"' .. clipboard .. "]p", {
  desc = "Paste from system",
})
setKeyMap("n", "gP", '"' .. clipboard .. "]P", {
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
setKeyMap("n", "<leader>bb", fzf.buffers, {
  silent = true,
  desc = "List",
})
setKeyMap("n", "<leader>bd", function()
  local lastBuf = vim.api.nvim_win_get_buf(0)
  vim.cmd("edit " .. mong8se.directoryFromContext())
  vim.schedule(function() vim.api.nvim_buf_delete(lastBuf, {}) end)
end, {
  silent = true,
  desc = "Delete current buffer",
})
setKeyMap("n", "<leader>bs", fzf.lsp_document_symbols, {
  silent = true,
  desc = "Symbols",
})
setKeyMap("n", "<leader>bx", fzf.diagnostics_document, {
  silent = true,
  desc = "Diagnostics",
})
setKeyMap("n", "<leader>b/", fzf.lgrep_curbuf, {
  silent = true,
  desc = "Search in buffer",
})
setKeyMap("n", "<leader>;", require("buffish.shortcuts").follow, {
  desc = "Go to Buffish shortcut",
})

-- file
setKeyMap(
  "n",
  "<leader>f-",
  function() vim.cmd("edit " .. mong8se.directoryFromContext()) end,
  {
    silent = true,
    desc = "Browse files from here",
  }
)
setKeyMap("n", "<leader>ff", function() vim.cmd("edit .") end, {
  silent = true,
  desc = "Browse files from root",
})
setKeyMap("n", "<leader>f/", fzf.lgrep_curbuf, {
  desc = "Search on current file",
})

setKeyMap("n", "<leader>fz", fzf.files, {
  desc = "Search for file",
})

-- toggle
setKeyMap("n", "<leader>tn", mong8se.toggleNumberMode, {
  silent = true,
  desc = "Toggle numbers",
})
setKeyMap("n", "<leader>tb", mong8se.toggleScrollBindAllWindows, {
  silent = true,
  desc = "Toggle scroll bind",
})
setKeyMap("n", "<leader>tc", fzf.colorschemes, {
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
setKeyMap("n", "<leader>pp", mong8se.activateGitOrFiles, {
  silent = true,
  desc = "Find project files",
})
setKeyMap("n", "<leader>ps", fzf.lsp_workspace_symbols, {
  silent = true,
  desc = "Symbols",
})
setKeyMap("n", "<leader>px", fzf.diagnostics_workspace, {
  silent = true,
  desc = "Diagnostics",
})
setKeyMap("n", "<leader>p/", fzf.live_grep, {
  silent = true,
  desc = "Search in project",
})

-- git
setKeyMap("n", "<leader>gg", fzf.git_status, {
  silent = true,
  desc = "Git status",
})
setKeyMap("n", "<leader>gl", fzf.git_commits, {
  silent = true,
  desc = "Git log",
})
setKeyMap("n", "<leader>gc", fzf.git_bcommits, {
  silent = true,
  desc = "Git log for buffer",
})
setKeyMap("n", "<leader>gb", fzf.git_branches, {
  silent = true,
  desc = "Git branches",
})
setKeyMap("n", "<leader>gs", fzf.git_stash, {
  silent = true,
  desc = "Git stash",
})

-- search
setKeyMap("n", "<leader>sl", fzf.live_grep, {
  desc = "Search live",
})
setKeyMap("n", "<leader>sf", fzf.lgrep_curbuf, {
  desc = "Search on current file",
})
setKeyMap("n", "<leader>sp", fzf.grep_project, {
  desc = "Search all lines in project",
})
setKeyMap("n", "<leader>sr", fzf.resume, {
  desc = "Resume last search",
})

-- diagnostics
setKeyMap("n", "<leader>xx", fzf.diagnostics_workspace, {
  silent = true,
  desc = "Diagnostics",
})
setKeyMap("n", "<leader>xb", fzf.diagnostics_document, {
  silent = true,
  desc = "Current Buffer",
})

-- window
setKeyMap("n", "<c-w>s", mong8se.splitCommand, {
  silent = true,
  desc = "Split and browse",
})
setKeyMap("n", "<c-w><C-s>", mong8se.splitCommand, {
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
