local mong8se = require("mong8se")

local setKeyMap = vim.keymap.set

local fzf = require("fzf-lua")

local MiniMisc = require("mini.misc")

local MiniClue = require('mini.clue')
MiniClue.setup({
  triggers = {
    -- Leader triggers
    {mode = 'n', keys = '<Leader>'}, {mode = 'x', keys = '<Leader>'},

    -- Built-in completion
    {mode = 'i', keys = '<C-x>'}, -- `g` key
    {mode = 'n', keys = 'g'}, {mode = 'x', keys = 'g'}, -- `[` key
    {mode = 'n', keys = '['}, {mode = 'x', keys = '['}, -- `]` key
    {mode = 'n', keys = ']'}, {mode = 'x', keys = ']'}, -- Marks
    {mode = 'n', keys = "'"}, {mode = 'n', keys = '`'},
    {mode = 'x', keys = "'"}, {mode = 'x', keys = '`'}, -- Registers
    {mode = 'n', keys = '"'}, {mode = 'x', keys = '"'},
    {mode = 'i', keys = '<C-r>'}, {mode = 'c', keys = '<C-r>'},

    -- Window commands
    {mode = 'n', keys = '<C-w>'}, -- `z` key
    {mode = 'n', keys = 'z'}, {mode = 'x', keys = 'z'}
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    MiniClue.gen_clues.builtin_completion(), MiniClue.gen_clues.g(),
    MiniClue.gen_clues.marks(),
    MiniClue.gen_clues.registers({show_contents = true}),
    MiniClue.gen_clues.windows(), MiniClue.gen_clues.z(),
    {mode = 'n', keys = '<Leader>b', desc = '+Buffer'},
    {mode = 'n', keys = '<Leader>c', desc = '+Code'},
    {mode = 'n', keys = '<Leader>f', desc = '+File'},
    {mode = 'n', keys = '<Leader>g', desc = '+Git'},
    {mode = 'n', keys = '<Leader>h', desc = '+Hunk'},
    {mode = 'n', keys = '<Leader>p', desc = '+Project'},
    {mode = 'n', keys = '<Leader>s', desc = '+Search'},
    {mode = 'n', keys = '<Leader>t', desc = '+Toggle'},
    {mode = 'n', keys = '<Leader>x', desc = '+Trouble'}
  },

  window = {delay = 333, config = {width = 'auto'}}
})

setKeyMap('n', "<leader> ", require("buffish").open,
          {silent = true, desc = "Switch buffer"})

setKeyMap('n', "<leader>:", fzf.commands, {desc = "Fuzzy command"})
setKeyMap('n', "<leader>'", fzf.marks, {desc = "Fuzzy marks"})
setKeyMap('n', '<leader>"', fzf.registers, {desc = "Fuzzy registers"})

setKeyMap('n', "gV", [['`[' . strpart(getregtype(), 0, 1) . '`]']],
          {expr = true, desc = "Switch to VISUAL selecting last pasted text"})

local clipboard = vim.fn.has('macunix') and "+" or "*"
setKeyMap('n', "gp", '"' .. clipboard .. ']p', {desc = "Paste from system"})
setKeyMap('n', "gP", '"' .. clipboard .. ']P',
          {desc = "Paste from system before"})

setKeyMap('n', "gR", "<cmd>TroubleToggle lsp_references<cr>",
          {desc = "LSP References"})

setKeyMap('n', "U", "<C-r>")
setKeyMap('n', "<f1>", '<Nop>')
setKeyMap('n', "Y", 'y$')

-- Instead of look up in man, let's split, opposite of J for join
-- setKeyMap('n', "K", "i<CR><Esc>")
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
setKeyMap('n', "<leader>bd", function()
  local lastBuf = vim.api.nvim_win_get_buf(0)
  vim.cmd("edit " .. mong8se.directoryFromContext())
  vim.schedule(function() vim.api.nvim_buf_delete(lastBuf, {}) end)
end, {silent = true, desc = "Delete current buffer"})
setKeyMap('n', "<leader>bs", fzf.lsp_document_symbols,
          {silent = true, desc = "Buffer symbols"})
setKeyMap('n', "<leader>bx", "<cmd>Trouble document_diagnostics<cr>",
          {silent = true, desc = "Buffer Diagnostics"})
setKeyMap('n', "<leader>bz", function()
  MiniMisc.zoom(0, {
    border = "double",
    height = vim.go.lines - vim.go.cmdheight - 3,
    width = vim.go.columns - 2
  })
end, {silent = true, desc = "Zoom a buffer"})
setKeyMap('n', "<leader>b/", fzf.lgrep_curbuf,
          {silent = true, desc = "Search in buffer"})
setKeyMap('n', "<leader>;", require("buffish.shortcuts").follow,
          {desc = "Go to Buffish shortcut"})

-- file
setKeyMap('n', "<leader>f-",
          function() vim.cmd("edit " .. mong8se.directoryFromContext()) end,
          {silent = true, desc = "Browse files from here"})
setKeyMap('n', "<leader>ff", function() vim.cmd("edit .") end,
          {silent = true, desc = "Browse files from root"})
setKeyMap('n', '<leader>f/', fzf.lgrep_curbuf,
          {desc = "Search on current file"})

-- toggle
setKeyMap('n', "<leader>tr", '<Plug>(golden_ratio_toggle)',
          {noremap = false, desc = "Toggle golden ratio", silent = true})
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
setKeyMap('n', "<leader>ti", "<cmd>IBLToggle<CR>",
          {desc = "Toggle indent blanklines"})

-- project
setKeyMap('n', "<leader>pp", mong8se.activateGitOrFiles,
          {silent = true, desc = "Find project files"})
setKeyMap('n', "<leader>pf", fzf.files, {silent = true, desc = "Find files"})
setKeyMap('n', "<leader>ps", fzf.lsp_workspace_symbols,
          {silent = true, desc = "Symbols"})
setKeyMap('n', "<leader>px", "<cmd>Trouble workspace_diagnostics<cr>",
          {silent = true, desc = "Trouble"})
setKeyMap('n', "<leader>p/", fzf.live_grep,
          {silent = true, desc = "Search in project"})

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
setKeyMap('n', '<leader>/',
          fzf.live_grep,
          {desc = "Live Grep"})
setKeyMap('n', '<leader>*',
          fzf.grep_cword,
          {desc = "Search current word"})
setKeyMap('v', '<leader>*',
          fzf.grep_visual,
          {desc = "Search current word"})
setKeyMap('n', '<leader>sf', fzf.lgrep_curbuf,
          {desc = "Search on current file"})
setKeyMap('n', '<leader>sp', fzf.grep_project,
          {desc = "Search all lines in project"})
setKeyMap('n', '<leader>sr', fzf.resume,
          {desc = "Resume last search"})

-- trouble
setKeyMap('n', "<leader>xx", "<cmd>Trouble<cr>",
          {silent = true, desc = "Trouble"})
setKeyMap('n', "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true})
setKeyMap('n', "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true})
setKeyMap('n', "<leader>xf", vim.diagnostic.open_float, {silent = true})
setKeyMap('n', "<leader>xg", vim.diagnostic.setloclist, {silent = true})

-- window
setKeyMap('n', "<c-w>s", mong8se.splitCommand,
          {silent = true, desc = "Split and browse"})
setKeyMap('n', "<c-w><C-s>", mong8se.splitCommand, {silent = true})
setKeyMap('n', "<c-w>\\", '<Plug>(golden_ratio_resize)', {silent = true})
setKeyMap('t', "<c-w><C-w>", "<C-\\><C-n>")

local readline = require 'readline'
setKeyMap('!', '<M-f>', readline.forward_word)
setKeyMap('!', '<M-b>', readline.backward_word)
setKeyMap('!', '<C-a>', readline.beginning_of_line)
setKeyMap('!', '<C-e>', readline.end_of_line)
setKeyMap('!', '<M-d>', readline.kill_word)
setKeyMap('!', '<M-BS>', readline.backward_kill_word)
setKeyMap('!', '<C-w>', readline.unix_word_rubout)
setKeyMap('!', '<C-k>', readline.kill_line)
setKeyMap('!', '<C-u>', readline.backward_kill_line)

return {
  gitsigns = function(gs, bufnr)
    -- h for hunk
    setKeyMap('n', ']h', gs.next_hunk, {desc = "Hunk forward", buffer = bufnr})
    setKeyMap('n', '[h', gs.prev_hunk, {desc = "Hunk last", buffer = bufnr})

    -- Actions
    setKeyMap('n', '<leader>hs', gs.stage_hunk,
              {buffer = bufnr, desc = "Stage hunk"})
    setKeyMap('n', '<leader>hr', gs.reset_hunk,
              {buffer = bufnr, desc = "Reset hunk"})
    setKeyMap('v', '<leader>hs', function()
      gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
    end, {buffer = bufnr, desc = "Stage Hunk"})
    setKeyMap('v', '<leader>hr', function()
      gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
    end, {buffer = bufnr, desc = "Reset hunk"})
    setKeyMap('n', '<leader>hS', gs.stage_buffer,
              {buffer = bufnr, desc = "Stage buffer"})
    setKeyMap('n', '<leader>hR', gs.reset_buffer,
              {buffer = bufnr, desc = "Reset buffer"})
    setKeyMap('n', '<leader>hu', gs.undo_stage_hunk,
              {buffer = bufnr, desc = 'Undo stage hunk'})
    setKeyMap('n', '<leader>hp', gs.preview_hunk,
              {buffer = bufnr, desc = "Preview hunk"})
    setKeyMap('n', '<leader>hb', function() gs.blame_line {full = true} end,
              {buffer = bufnr, desc = "Blame hunk"})
    setKeyMap('n', '<leader>tgb', gs.toggle_current_line_blame,
              {buffer = bufnr, desc = "Toggle git blame line"})
    setKeyMap('n', '<leader>hd', gs.diffthis,
              {buffer = bufnr, desc = "Hunk diff"})
    setKeyMap('n', '<leader>hD', function() gs.diffthis('~') end,
              {buffer = bufnr, desc = "Diff what"})
    setKeyMap('n', '<leader>tgd', gs.toggle_deleted,
              {buffer = bufnr, desc = "Toggle git deleted lines"})

    -- Text object
    setKeyMap({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
              {buffer = bufnr})
  end,

  lsp = function(vim_lsp, bufnr)
    setKeyMap('n', "gD", vim_lsp.buf.declaration,
              {silent = true, buffer = bufnr, desc = "Go to declaration"})
    setKeyMap('n', "gd", vim_lsp.buf.definition,
              {silent = true, buffer = bufnr, desc = "Go to definition"})
    setKeyMap('n', "K", vim_lsp.buf.hover, {silent = true, buffer = bufnr})
    setKeyMap('n', "\\", vim_lsp.buf.signature_help,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>wa", vim_lsp.buf.add_workspace_folder,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>wr", vim_lsp.buf.remove_workspace_folder,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>wl",
              function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>cf", vim_lsp.buf.format,
              {silent = true, buffer = bufnr, desc = "Format"})
    setKeyMap('n', "<leader>cr", vim_lsp.buf.rename,
              {silent = true, buffer = bufnr, desc = "Rename"})
    setKeyMap('n', '<leader>cd', vim_lsp.buf.type_definition,
              {silent = true, buffer = bufnr, desc = "Type definition"})

    vim.keymap.set("n", "<leader>th", function(event)
      vim.lsp.inlay_hint.enable(event.buf, not vim.lsp.inlay_hint.is_enabled())
    end, {desc = "Toggle inlay Hints"})
  end
}
