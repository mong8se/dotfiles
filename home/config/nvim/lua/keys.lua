local mong8se = require("mong8se")

local setKeyMap = vim.keymap.set

local fzf = require("fzf-lua")

local attachableBindings = {}

setKeyMap('n', "<leader> ", require("buffish").open,
          {silent = true, desc = "Switch buffer"})

setKeyMap('n', "<leader>/", '<Plug>CtrlSFPrompt',
          {noremap = false, silent = false, desc = "Search"})
setKeyMap('n', "<leader>*", '<Plug>CtrlSFCwordExec', {desc = "Search word"})
setKeyMap('n', "<leader>:", fzf.commands, {desc = "Fuzzy command"})
setKeyMap('n', "<leader>'", fzf.marks, {desc = "Fuzzy marks"})
setKeyMap('n', '<leader>"', fzf.registers, {desc = "Fuzzy registers"})

setKeyMap('n', "gV", [['`[' . strpart(getregtype(), 0, 1) . '`]']],
          {expr = true, desc = "Switch to VISUAL selecting last pasted text"})

local clipboard = vim.fn.has('macunix') and "+" or "*"
setKeyMap('n', "gp", '"' .. clipboard .. ']p', {desc = "Paste from system"})
setKeyMap('n', "gP", '"' .. clipboard .. ']P',
          {desc = "Paste from system before"})

setKeyMap('n', "gR", "<cmd>TroubleToggle lsp_references<cr>")

setKeyMap('n', "U", "<C-r>")
setKeyMap('n', "<f1>", '<Nop>')
setKeyMap('n', "Y", 'y$')

-- Instead of look up in man, let's split, opposite of J for join
setKeyMap('n', "K", "i<CR><Esc>")
setKeyMap('n', "<C-L>",
          ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>",
          {silent = true})
setKeyMap('n', "<Down>", "gj")
setKeyMap('n', "<Up>", "gk")
setKeyMap('n', "<C-k>", "<C-e>gk")
setKeyMap('n', "<C-j>", "<C-y>gj")
setKeyMap('n', "<S-Up>", "v<Up>")
setKeyMap('n', "<S-Down>", "v<Down>")
setKeyMap('n', "<S-Left>", "v<Left>")
setKeyMap('n', "<S-Right>", "v<Right>")
setKeyMap('n', "+", "$e^", {desc = "Down to next non blank line"})
setKeyMap('n', "-", [[:keeppatterns call search("^\\s*\\S", "be")<cr>]],
          {desc = "Up to previous non blank line"})

setKeyMap('n', "go", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>",
          {silent = true, desc = "Blank line below"})

setKeyMap('n', "gO", ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[",
          {silent = true, desc = "Blank line above"})

setKeyMap('v', "<S-Up>", "<Up>")
setKeyMap('v', "<S-Down>", "<Down>")
setKeyMap('v', "<S-Left>", "<Left>")
setKeyMap('v', "<S-Right>", "<Right>")
setKeyMap('v', "<C-j>", ":m '>+1<CR>gv=gv", {desc = "Move selection down"})
setKeyMap('v', "<C-k>", ":m '<-2<CR>gv=gv", {desc = "Move selection up"})
setKeyMap('v', "<", "<gv")
setKeyMap('v', ">", ">gv")
setKeyMap('v', '/', mong8se.visualSearch)

-- buffer
setKeyMap('n', "<leader>bb", fzf.buffers,
          {silent = true, desc = "Buffer switch"})
-- setKeyMap('n', "<leader>bd", ":bufdo ", {silent = false})
setKeyMap('n', "<leader>bd", function()
  local lastBuf = vim.api.nvim_win_get_buf(0)
  vim.cmd("edit " .. mong8se.directoryFromContext())
  vim.schedule(function() vim.api.nvim_buf_delete(lastBuf, {}) end)
end, {silent = true, desc = "Delete current buffer"})

-- file
setKeyMap('n', "<leader>f-",
          function() vim.cmd("edit " .. mong8se.directoryFromContext()) end,
          {silent = true, desc = "Browse files from here"})
setKeyMap('n', "<leader>ff", function() vim.cmd("edit .") end,
          {silent = true, desc = "Browse files from root"})

-- toggle
setKeyMap('n', "<leader>tg", '<Plug>(golden_ratio_toggle)',
          {noremap = false, desc = "Toggle golden ratio"})
setKeyMap('n', "<leader>tm", require('mini.map').toggle,
          {desc = "Toggle mini map"})
setKeyMap('n', "<leader>tn", mong8se.toggleNumberMode,
          {silent = true, desc = "Toggle numbers"})
setKeyMap('n', "<leader>tb", mong8se.toggleScrollBindAllWindows,
          {silent = true, desc = "Toggle scroll bind"})
setKeyMap('n', "<leader>tc", fzf.colorschemes,
          {silent = true, desc = "Toggle colorscheme"})
setKeyMap('n', "<leader>ts", "<cmd>setlocal spell!<CR><cmd>set spell?<CR>",
          {silent = true, desc = "Toggle spell check"})
setKeyMap('n', "<leader>tw", "<cmd>setlocal wrap!<CR><cmd>set wrap?<CR>",
          {silent = true, desc = "Toggle line wrap"})
setKeyMap('n', "<leader>tp", "<cmd>setlocal paste!<CR><cmd>set paste?<CR>",
          {silent = true, desc = "Toggle paste"})

-- code
setKeyMap('n', "<leader>c*", fzf.lsp_references, {silent = true})

-- jump
setKeyMap('n', "<leader>jc", fzf.lsp_document_symbols, {silent = true})
setKeyMap('n', "<leader>Jc", fzf.lsp_workspace_symbols, {silent = true})

-- project
setKeyMap('n', "<leader>pp", mong8se.activateGitOrFiles,
          {silent = true, desc = "Find project files"})
setKeyMap('n', "<leader>pf", fzf.files, {silent = true, desc = "Find files"})

-- git
setKeyMap('n', "<leader>gg", fzf.git_status,
          {silent = true, desc = "Git status"})
setKeyMap('n', "<leader>gl", fzf.git_commits, {silent = true, desc = "Git log"})
setKeyMap('n', "<leader>gc", fzf.git_bcommits,
          {silent = true, desc = "Git log for buffer"})
setKeyMap('n', "<leader>gb", fzf.git_branches,
          {silent = true, desc = "Git branches"})
setKeyMap('n', "<leader>gs", fzf.git_stash, {silent = true, desc = "Git stash"})

-- search
setKeyMap('n', "<leader>sr", ':CtrlSFOpen<CR>',
          {silent = true, desc = "Resume search"})
setKeyMap('n', "<leader>sp", fzf.live_grep,
          {silent = true, desc = "Search project"})
setKeyMap('n', "<leader>sh", fzf.search_history,
          {silent = true, desc = "Search history"})
setKeyMap('n', "<leader>sb", fzf.lgrep_curbuf,
          {silent = true, desc = "Search buffer"})

-- trouble
setKeyMap('n', "<leader>xx", "<cmd>Trouble<cr>", {silent = true})
setKeyMap('n', "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
          {silent = true})
setKeyMap('n', "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
          {silent = true})
setKeyMap('n', "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true})
setKeyMap('n', "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true})
setKeyMap('n', "<leader>xf", vim.diagnostic.open_float, {silent = true})
setKeyMap('n', "<leader>xg", vim.diagnostic.setloclist, {silent = true})

-- window
setKeyMap('n', "<c-w>s", mong8se.splitCommand, {silent = true})
setKeyMap('n', "<c-w><C-s>", mong8se.splitCommand, {silent = true})
setKeyMap('n', "<c-w>\\", '<Plug>(golden_ratio_resize)', {silent = true})
setKeyMap('t', "<c-w><C-w>", "<C-\\><C-n>")

attachableBindings.gitsigns = function(gs, bufnr)
  -- h for hunk
  setKeyMap('n', ']h', gs.next_hunk, {desc = "Hunk forward", buffer = bufnr})
  setKeyMap('n', '[h', gs.prev_hunk, {desc = "Hunk last", buffer = bufnr})

  -- Actions
  setKeyMap('n', '<leader>hs', gs.stage_hunk, {buffer = bufnr})
  setKeyMap('n', '<leader>hr', gs.reset_hunk, {buffer = bufnr})
  setKeyMap('v', '<leader>hs',
            function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
            {buffer = bufnr})
  setKeyMap('v', '<leader>hr',
            function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
            {buffer = bufnr})
  setKeyMap('n', '<leader>hS', gs.stage_buffer, {buffer = bufnr})
  setKeyMap('n', '<leader>hu', gs.undo_stage_hunk, {buffer = bufnr})
  setKeyMap('n', '<leader>hR', gs.reset_buffer, {buffer = bufnr})
  setKeyMap('n', '<leader>hp', gs.preview_hunk, {buffer = bufnr})
  setKeyMap('n', '<leader>hb', function() gs.blame_line {full = true} end,
            {buffer = bufnr})
  setKeyMap('n', '<leader>tgb', gs.toggle_current_line_blame, {buffer = bufnr})
  setKeyMap('n', '<leader>hd', gs.diffthis, {buffer = bufnr})
  setKeyMap('n', '<leader>hD', function() gs.diffthis('~') end, {buffer = bufnr})
  setKeyMap('n', '<leader>tgd', gs.toggle_deleted, {buffer = bufnr})

  -- Text object
  setKeyMap({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {buffer = bufnr})
end

attachableBindings.lsp = function(lsp, bufnr)
  setKeyMap('n', "gD", lsp.buf.declaration,
            {silent = true, buffer = bufnr, desc = "Go to declaration"})
  setKeyMap('n', "gd", lsp.buf.definition,
            {silent = true, buffer = bufnr, desc = "Go to definition"})
  setKeyMap('n', "K", lsp.buf.hover, {silent = true, buffer = bufnr})
  setKeyMap('n', "\\", lsp.buf.signature_help, {silent = true, buffer = bufnr})
  setKeyMap('n', "<leader>wa", lsp.buf.add_workspace_folder,
            {silent = true, buffer = bufnr})
  setKeyMap('n', "<leader>wr", lsp.buf.remove_workspace_folder,
            {silent = true, buffer = bufnr})
  setKeyMap('n', "<leader>wl",
            '<cmd>lua print(vim.inspect(lsp.buf.list_workspace_folders()))<CR>',
            {silent = true, buffer = bufnr})
  setKeyMap('n', "<leader>cf", lsp.buf.formatting,
            {silent = true, buffer = bufnr})
  setKeyMap('n', "<leader>cr", lsp.buf.rename, {silent = true, buffer = bufnr})
  setKeyMap('n', '<leader>cd', lsp.buf.type_definition,
            {silent = true, buffer = bufnr})
end

return attachableBindings
