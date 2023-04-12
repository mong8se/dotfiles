local mong8se = require("mong8se")

local setKeyMap = vim.keymap.set

local fzf = require("fzf-lua")

local attachableBindings = {}

setKeyMap('n', "<leader>bb", ":Buffish<CR>", {silent = true})
setKeyMap('n', "<leader>bn", ":bn<CR>")
setKeyMap('n', "<leader>bp", ":bp<CR>")
setKeyMap('n', "<leader>bd", ":bufdo ", {silent = false})

setKeyMap('n', "<leader>f-",
          function() vim.cmd("edit " .. mong8se.directoryFromContext()) end,
          {silent = true})


setKeyMap('n', "<leader>tg", '<Plug>(golden_ratio_toggle)', {noremap = false})
setKeyMap('n', "<leader>tm", require('mini.map').toggle)
setKeyMap('n', "<leader>tn", mong8se.toggleNumberMode, {silent = true})
setKeyMap('n', "<leader>tb", mong8se.toggleScrollBindAllWindows, {silent = true})
setKeyMap('n', "<leader>tc", fzf.colorschemes, {silent = true})
setKeyMap('n', "<leader>tt", "<cmd>TroubleToggle<cr>")
setKeyMap('n', "<leader>tw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>")
setKeyMap('n', "<leader>td", "<cmd>TroubleToggle lsp_document_diagnostics<cr>")
setKeyMap('n', "<leader>tq", "<cmd>TroubleToggle quickfix<cr>")
setKeyMap('n', "<leader>tl", "<cmd>TroubleToggle loclist<cr>")
setKeyMap('n', "<leader>ts", "<cmd>setlocal spell!<CR>", {silent = true})

setKeyMap('n', "<leader>c/", fzf.lsp_references, {silent = true})
setKeyMap('n', "<leader>jc", fzf.lsp_document_symbols,
          {silent = true})
setKeyMap('n', "<leader>Jc", fzf.lsp_workspace_symbols,
          {silent = true})

setKeyMap('n', "<leader>pp", mong8se.activateGitOrFiles, {silent = true})
setKeyMap('n', "<leader>pf", fzf.files, {silent = true})

setKeyMap('n', "<leader>gg", fzf.git_status, {silent = true})
setKeyMap('n', "<leader>gl", fzf.git_commits, {silent = true})
setKeyMap('n', "<leader>gc", fzf.git_bcommits, {silent = true})
setKeyMap('n', "<leader>gb", fzf.git_branches, {silent = true})
setKeyMap('n', "<leader>gs", fzf.git_stash, {silent = true})

setKeyMap('n', "<leader>sr", ':CtrlSFOpen<CR>', {silent = true})
setKeyMap('n', "<leader>sp", fzf.live_grep, {silent = true})
setKeyMap('n', "<leader>sh", fzf.search_history, {silent = true})
setKeyMap('n', "<leader>sb", fzf.lgrep_curbuf, {silent = true})

setKeyMap('n', "<leader>xx", "<cmd>Trouble<cr>", {silent = true})
setKeyMap('n', "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
          {silent = true})
setKeyMap('n', "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
          {silent = true})
setKeyMap('n', "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true})
setKeyMap('n', "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true})
setKeyMap('n', "<leader>xf", vim.diagnostic.open_float, {silent = true})
setKeyMap('n', "<leader>xg", vim.diagnostic.setloclist, {silent = true})
setKeyMap('n', "<leader> ", fzf.buffers, {silent = true})
setKeyMap('n', "<leader>/", '<Plug>CtrlSFPrompt',
          {noremap = false, silent = false})
setKeyMap('n', "<leader>*", '<Plug>CtrlSFCwordExec')
setKeyMap('n', "<leader>:", fzf.commands)
setKeyMap('n', "<leader>'", fzf.marks)
setKeyMap('n', '<leader>"', fzf.registers)

setKeyMap('n', "<c-w>s", mong8se.splitCommand, {silent = true})
setKeyMap('n', "<c-w><C-s>", mong8se.splitCommand, {silent = true})
setKeyMap('n', "<c-w>\\", '<Plug>(golden_ratio_resize)', {silent = true})
setKeyMap('t', "<c-w><C-w>", "<C-\\><C-n>")

setKeyMap('n', "\\", [['`[' . strpart(getregtype(), 0, 1) . '`]']],
          {expr = true})

local clipboard = vim.fn.has('macunix') and "+" or "*"

setKeyMap('n', "gp", '"' .. clipboard .. ']p')
setKeyMap('n', "gP", '"' .. clipboard .. ']P')

setKeyMap('n', "gR", "<cmd>TroubleToggle lsp_references<cr>")

setKeyMap('n', "U", "<C-r>")
setKeyMap('n', "<f1>", '<Nop>')
setKeyMap('n', "Y", 'y$')

-- Instead of look up in man, let"s split, opposite of J for join
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
setKeyMap('n', "+", "$e^")
setKeyMap('n', "-", [[:keeppatterns call search("^\\s*\\S", "be")<cr>]])

setKeyMap('n', "]t", ':tabnext<CR>', {silent = true})
setKeyMap('n', "]b", ':bn<CR>', {silent = true})
setKeyMap('n', "]d", vim.diagnostic.goto_next, {silent = true})
setKeyMap('n', "]<cr>", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>",
          {silent = true})

setKeyMap('n', "[t", ':tabprevious<CR>', {silent = true})
setKeyMap('n', "[b", ':bp<CR>', {silent = true})
setKeyMap('n', "[d", vim.diagnostic.goto_prev, {silent = true})
setKeyMap('n', "[<cr>", ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[",
          {silent = true})

setKeyMap('v', "<C-j>", "<ESC>:m .+1<CR>==gi")
setKeyMap('v', "<C-k>", "<ESC>:m .-2<CR>==gi")
setKeyMap('v', "<S-Up>", "<Esc>v<Up>")
setKeyMap('v', "<S-Down>", "<Esc>v<Down>")
setKeyMap('v', "<S-Left>", "<Esc>v<Left>")
setKeyMap('v', "<S-Right>", "<Esc>v<Right>")
setKeyMap('v', "<S-Up>", "<Up>")
setKeyMap('v', "<S-Down>", "<Down>")
setKeyMap('v', "<S-Left>", "<Left>")
setKeyMap('v', "<S-Right>", "<Right>")
setKeyMap('v', "<C-j>", ":m '>+1<CR>gv=gv")
setKeyMap('v', "<C-k>", ":m '<-2<CR>gv=gv")
setKeyMap('v', "<", "<gv")
setKeyMap('v', ">", ">gv")
setKeyMap('v', '/', mong8se.visualSearch)

attachableBindings.gitsigns = function(gs, bufnr)
    setKeyMap('n', "]c", function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end, {expr = true, buffer = bufnr})
    setKeyMap('n', "[c", function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end);
        return '<Ignore>';
    end, {expr = true, buffer = bufnr})
    setKeyMap('n', "<leader>hs", ':Gitsigns stage_hunk<CR>', {buffer = bufnr})
    setKeyMap('n', "<leader>hr", ':Gitsigns reset_hunk<CR>', {buffer = bufnr})
    setKeyMap('n', "<leader>hS", gs.stage_buffer, {buffer = bufnr})
    setKeyMap('n', "<leader>hu", gs.undo_stage_hunk, {buffer = bufnr})
    setKeyMap('n', "<leader>hR", gs.reset_buffer, {buffer = bufnr})
    setKeyMap('n', "<leader>hp", gs.preview_hunk, {buffer = bufnr})
    setKeyMap('n', "<leader>hb", function() gs.blame_line {full = true} end,
              {buffer = bufnr})
    setKeyMap('n', "<leader>tb", gs.toggle_current_line_blame, {buffer = bufnr})
    setKeyMap('n', "<leader>hd", gs.diffthis, {buffer = bufnr})
    setKeyMap('n', "<leader>hD", function() gs.diffthis('~') end,
              {buffer = bufnr})
    setKeyMap('n', "<leader>td", gs.toggle_deleted, {buffer = bufnr})
    setKeyMap('x', "ih", ':<C-U>Gitsigns select_hunk<CR>', {buffer = bufnr})
    setKeyMap('v', "<leader>hs", ':Gitsigns stage_hunk<CR>', {buffer = bufnr})
    setKeyMap('v', "<leader>hr", ':Gitsigns reset_hunk<CR>', {buffer = bufnr})
    setKeyMap('o', "ih", ':<C-U>Gitsigns select_hunk<CR>', {buffer = bufnr})
end

attachableBindings.lsp = function(lsp, bufnr)
    setKeyMap('n', "gD", lsp.buf.declaration,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "gd", lsp.buf.definition, {silent = true, buffer = bufnr})
    setKeyMap('n', "K", lsp.buf.hover, {silent = true, buffer = bufnr})
    setKeyMap('n', "\\", lsp.buf.signature_help,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>wa", lsp.buf.add_workspace_folder,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>wr", lsp.buf.remove_workspace_folder,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>wl",
              '<cmd>lua print(vim.inspect(lsp.buf.list_workspace_folders()))<CR>',
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>cf", lsp.buf.formatting,
              {silent = true, buffer = bufnr})
    setKeyMap('n', "<leader>cr", lsp.buf.rename,
              {silent = true, buffer = bufnr})
    setKeyMap('n', '<leader>cd', lsp.buf.type_definition,
              {silent = true, buffer = bufnr})
end

return attachableBindings
