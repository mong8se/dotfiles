local mong8se = require("mong8se")

local attachableBindings = {}

vim.keymap.set('n', "<leader>bb", ":Buffish<CR>", {silent = true})
vim.keymap.set('n', "<leader>bn", ":bn<CR>")
vim.keymap.set('n', "<leader>bp", ":bp<CR>")
vim.keymap.set('n', "<leader>bd", ":bufdo ", {silent = false})

vim.keymap.set('n', "<leader>f-", function()
    vim.cmd("edit " .. mong8se.directoryFromContext())
end, {silent = true})

vim.keymap.set('n', "<leader>tg", '<Plug>(golden_ratio_toggle)',
               {noremap = false})
vim.keymap.set('n', "<leader>tm", require('mini.map').toggle)
vim.keymap.set('n', "<leader>tn", mong8se.toggleNumberMode, {silent = true})
vim.keymap.set('n', "<leader>tb", mong8se.toggleScrollBindAllWindows,
               {silent = true})
vim.keymap.set('n', "<leader>tc", require("fzf-lua").colorschemes,
               {silent = true})
vim.keymap.set('n', "<leader>tt", "<cmd>TroubleToggle<cr>")
vim.keymap.set('n', "<leader>tw",
               "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>")
vim.keymap.set('n', "<leader>td",
               "<cmd>TroubleToggle lsp_document_diagnostics<cr>")
vim.keymap.set('n', "<leader>tq", "<cmd>TroubleToggle quickfix<cr>")
vim.keymap.set('n', "<leader>tl", "<cmd>TroubleToggle loclist<cr>")
vim.keymap.set('n', "<leader>ts", "<cmd>setlocal spell!<CR>", {silent = true})

vim.keymap.set('n', "<leader>c/", require("fzf-lua").lsp_references,
               {silent = true})
vim.keymap.set('n', "<leader>jc", require("fzf-lua").lsp_document_symbols,
               {silent = true})
vim.keymap.set('n', "<leader>Jc", require("fzf-lua").lsp_workspace_symbols,
               {silent = true})

vim.keymap.set('n', "<leader>pp", mong8se.activateGitOrFiles, {silent = true})
vim.keymap.set('n', "<leader>pf", require('fzf-lua').files, {silent = true})

vim.keymap
    .set('n', "<leader>gg", require("fzf-lua").git_status, {silent = true})
vim.keymap.set('n', "<leader>gl", require("fzf-lua").git_commits,
               {silent = true})
vim.keymap.set('n', "<leader>gc", require("fzf-lua").git_bcommits,
               {silent = true})
vim.keymap.set('n', "<leader>gb", require("fzf-lua").git_branches,
               {silent = true})
vim.keymap.set('n', "<leader>gs", require("fzf-lua").git_stash, {silent = true})

vim.keymap.set('n', "<leader>sr", ':CtrlSFOpen<CR>', {silent = true})
vim.keymap.set('n', "<leader>sp", require("fzf-lua").live_grep, {silent = true})
vim.keymap.set('n', "<leader>sh", require("fzf-lua").search_history,
               {silent = true})
vim.keymap.set('n', "<leader>sb", require("fzf-lua").lgrep_curbuf,
               {silent = true})

vim.keymap.set('n', "<leader>xx", "<cmd>Trouble<cr>", {silent = true})
vim.keymap.set('n', "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
               {silent = true})
vim.keymap.set('n', "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
               {silent = true})
vim.keymap.set('n', "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true})
vim.keymap.set('n', "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true})
vim.keymap.set('n', "<leader>xf", vim.diagnostic.open_float, {silent = true})
vim.keymap.set('n', "<leader>xg", vim.diagnostic.setloclist, {silent = true})
vim.keymap.set('n', "<leader> ", require('fzf-lua').buffers, {silent = true})
vim.keymap.set('n', "<leader>/", '<Plug>CtrlSFPrompt',
               {noremap = false, silent = false})
vim.keymap.set('n', "<leader>*", '<Plug>CtrlSFCwordExec')
vim.keymap.set('n', "<leader>:", require("fzf-lua").commands)
vim.keymap.set('n', "<leader>'", require("fzf-lua").marks)
vim.keymap.set('n', '<leader>"', require("fzf-lua").registers)

vim.keymap.set('n', "<c-w>s", mong8se.splitCommand, {silent = true})
vim.keymap.set('n', "<c-w><C-s>", mong8se.splitCommand, {silent = true})
vim.keymap.set('n', "<c-w>\\", '<Plug>(golden_ratio_resize)', {silent = true})
vim.keymap.set('t', "<c-w><C-w>", "<C-\\><C-n>")

vim.keymap.set('n', "\\", [['`[' . strpart(getregtype(), 0, 1) . '`]']],
               {expr = true})

local clipboard = vim.fn.has('macunix') and "+" or "*"

vim.keymap.set('n', "gp", '"' .. clipboard .. ']p')
vim.keymap.set('n', "gP", '"' .. clipboard .. ']P')

vim.keymap.set('n', "gR", "<cmd>TroubleToggle lsp_references<cr>")

vim.keymap.set('n', "U", "<C-r>")
vim.keymap.set('n', "<f1>", '<Nop>')
vim.keymap.set('n', "Y", 'y$')

-- Instead of look up in man, let"s split, opposite of J for join
vim.keymap.set('n', "K", "i<CR><Esc>")
vim.keymap.set('n', "<C-L>",
               ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>",
               {silent = true})
vim.keymap.set('n', "<Down>", "gj")
vim.keymap.set('n', "<Up>", "gk")
vim.keymap.set('n', "<C-k>", "<C-e>gk")
vim.keymap.set('n', "<C-j>", "<C-y>gj")
vim.keymap.set('n', "<S-Up>", "v<Up>")
vim.keymap.set('n', "<S-Down>", "v<Down>")
vim.keymap.set('n', "<S-Left>", "v<Left>")
vim.keymap.set('n', "<S-Right>", "v<Right>")
vim.keymap.set('n', "+", "$e^")
vim.keymap.set('n', "-", [[:keeppatterns call search("^\\s*\\S", "be")<cr>]])

vim.keymap.set('n', "]t", ':tabnext<CR>', {silent = true})
vim.keymap.set('n', "]b", ':bn<CR>', {silent = true})
vim.keymap.set('n', "]d", vim.diagnostic.goto_next, {silent = true})
vim.keymap.set('n', "]<cr>", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>",
               {silent = true})

vim.keymap.set('n', "[t", ':tabprevious<CR>', {silent = true})
vim.keymap.set('n', "[b", ':bp<CR>', {silent = true})
vim.keymap.set('n', "[d", vim.diagnostic.goto_prev, {silent = true})
vim.keymap.set('n', "[<cr>", ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[",
               {silent = true})

vim.keymap.set('v', "<C-j>", "<ESC>:m .+1<CR>==gi")
vim.keymap.set('v', "<C-k>", "<ESC>:m .-2<CR>==gi")
vim.keymap.set('v', "<S-Up>", "<Esc>v<Up>")
vim.keymap.set('v', "<S-Down>", "<Esc>v<Down>")
vim.keymap.set('v', "<S-Left>", "<Esc>v<Left>")
vim.keymap.set('v', "<S-Right>", "<Esc>v<Right>")
vim.keymap.set('v', "<S-Up>", "<Up>")
vim.keymap.set('v', "<S-Down>", "<Down>")
vim.keymap.set('v', "<S-Left>", "<Left>")
vim.keymap.set('v', "<S-Right>", "<Right>")
vim.keymap.set('v', "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "<C-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set('v', "<", "<gv")
vim.keymap.set('v', ">", ">gv")
vim.keymap.set('v', '/', mong8se.visualSearch)

attachableBindings.gitsigns = function(gs, bufnr)
    vim.keymap.set('n', "]c", function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end, {expr = true, buffer = bufnr})
    vim.keymap.set('n', "[c", function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end);
        return '<Ignore>';
    end, {expr = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>hs", ':Gitsigns stage_hunk<CR>',
                   {buffer = bufnr})
    vim.keymap.set('n', "<leader>hr", ':Gitsigns reset_hunk<CR>',
                   {buffer = bufnr})
    vim.keymap.set('n', "<leader>hS", gs.stage_buffer, {buffer = bufnr})
    vim.keymap.set('n', "<leader>hu", gs.undo_stage_hunk, {buffer = bufnr})
    vim.keymap.set('n', "<leader>hR", gs.reset_buffer, {buffer = bufnr})
    vim.keymap.set('n', "<leader>hp", gs.preview_hunk, {buffer = bufnr})
    vim.keymap.set('n', "<leader>hb",
                   function() gs.blame_line {full = true} end, {buffer = bufnr})
    vim.keymap.set('n', "<leader>tb", gs.toggle_current_line_blame,
                   {buffer = bufnr})
    vim.keymap.set('n', "<leader>hd", gs.diffthis, {buffer = bufnr})
    vim.keymap.set('n', "<leader>hD", function() gs.diffthis('~') end,
                   {buffer = bufnr})
    vim.keymap.set('n', "<leader>td", gs.toggle_deleted, {buffer = bufnr})
    vim.keymap
        .set('x', "ih", ':<C-U>Gitsigns select_hunk<CR>', {buffer = bufnr})
    vim.keymap.set('v', "<leader>hs", ':Gitsigns stage_hunk<CR>',
                   {buffer = bufnr})
    vim.keymap.set('v', "<leader>hr", ':Gitsigns reset_hunk<CR>',
                   {buffer = bufnr})
    vim.keymap
        .set('o', "ih", ':<C-U>Gitsigns select_hunk<CR>', {buffer = bufnr})
end

attachableBindings.lsp = function(bufnr)
    vim.keymap.set('n', "gD", vim.lsp.buf.declaration,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "gd", vim.lsp.buf.definition,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "K", vim.lsp.buf.hover, {silent = true, buffer = bufnr})
    vim.keymap.set('n', "\\", vim.lsp.buf.signature_help,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>wa", vim.lsp.buf.add_workspace_folder,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>wr", vim.lsp.buf.remove_workspace_folder,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>wl",
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>cf", vim.lsp.buf.formatting,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>cr", vim.lsp.buf.rename,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', '<leader>cd', vim.lsp.buf.type_definition,
                   {silent = true, buffer = bufnr})
end

return attachableBindings
