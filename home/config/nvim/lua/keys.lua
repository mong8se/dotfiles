local mong8se = require("mong8se")
local global = vim.g

global.mapleader = " "

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
vim.keymap.set('n', "<leader>tc", ":Telescope colorscheme<cr>", {silent = true})
vim.keymap.set('n', "<leader>tt", "<cmd>TroubleToggle<cr>")
vim.keymap.set('n', "<leader>tw",
               "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>")
vim.keymap.set('n', "<leader>td",
               "<cmd>TroubleToggle lsp_document_diagnostics<cr>")
vim.keymap.set('n', "<leader>tq", "<cmd>TroubleToggle quickfix<cr>")
vim.keymap.set('n', "<leader>tl", "<cmd>TroubleToggle loclist<cr>")
vim.keymap.set('n', "<leader>ts", "<cmd>setlocal spell!<CR>", {silent = true})

vim.keymap.set('n', "<leader>c/", ':Telescope lsp_references<CR>',
               {silent = true})
vim.keymap.set('n', "<leader>jc", ':Telescope lsp_document_symbols<CR>',
               {silent = true})
vim.keymap.set('n', "<leader>Jc",
               ':Telescope lsp_dynamic_workspace_symbols<CR>', {silent = true})
vim.keymap.set('n', "<leader>tc", ':Telescope treesitter<CR>', {silent = true})

vim.keymap.set('n', "<leader>pp", mong8se.activateGitOrFiles, {silent = true})
vim.keymap.set('n', "<leader>pf", ':Telescope find_files<CR>', {silent = true})

vim.keymap.set('n', "<leader>sr", ':CtrlSFOpen<CR>', {silent = true})
vim.keymap.set('n', "<leader>sp", ':Telescope live_grep<CR>', {silent = true})
vim.keymap.set('n', "<leader>sh", ':Telescope search_history<CR>',
               {silent = true})
vim.keymap.set('n', "<leader>sb", ':Telescope current_buffer_fuzzy_find<CR>',
               {silent = true})

vim.keymap.set('n', "<leader>xx", "<cmd>Trouble<cr>", {silent = true})
vim.keymap.set('n', "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
               {silent = true})
vim.keymap.set('n', "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
               {silent = true})
vim.keymap.set('n', "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true})
vim.keymap.set('n', "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true})
vim.keymap.set('n', "<leader>xf", function() vim.diagnostic.open_float() end,
               {silent = true})
vim.keymap.set('n', "<leader>xg", function() vim.diagnostic.setloclist() end,
               {silent = true})
vim.keymap.set('n', "<leader> ", ":Buffish<CR>", {silent = true})
vim.keymap.set('n', "<leader>/", '<Plug>CtrlSFPrompt',
               {noremap = false, silent = false})
vim.keymap.set('n', "<leader>*", '<Plug>CtrlSFCwordExec')
vim.keymap.set('n', "<leader>:", ':Telescope commands<CR>')
vim.keymap.set('n', "<leader>'", ':Telescope marks<CR>')

vim.keymap.set('n', "<c-w>s", mong8se.splitCommand, {silent = true})
vim.keymap.set('n', "<c-w><C-s>", mong8se.splitCommand, {silent = true})
vim.keymap.set('n', "<c-w>\\", '<Plug>(golden_ratio_resize)', {silent = true})
vim.keymap.set('t', "<c-w><C-w>", "<C-\\><C-n>")

vim.keymap.set('n', "\\", [['`[' . strpart(getregtype(), 0, 1) . '`]']],
               {expr = true})
vim.keymap.set('n', "gp", '"+]p')
vim.keymap.set('n', "gP", '"+]P')
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
vim.keymap.set('n', "]d", function() vim.diagnostic.goto_next() end,
               {silent = true})
vim.keymap.set('n', "]<cr>", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>",
               {silent = true})

vim.keymap.set('n', "[t", ':tabprevious<CR>', {silent = true})
vim.keymap.set('n', "[b", ':bp<CR>', {silent = true})
vim.keymap.set('n', "[d", function() vim.diagnostic.goto_prev() end,
               {silent = true})
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
    vim.keymap.set('n', "gD", '<cmd>lua vim.lsp.buf.declaration()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "gd", '<cmd>lua vim.lsp.buf.definition()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "K", '<cmd>lua vim.lsp.buf.hover()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "\\", '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>wa",
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>wr",
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>wl",
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>cf", '<cmd>lua vim.lsp.buf.formatting()<CR>',
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', "<leader>cr", function() vim.lsp.buf.rename() end,
                   {silent = true, buffer = bufnr})
    vim.keymap.set('n', '<leader>cd',
                   function() vim.lsp.buf.type_definition() end,
                   {silent = true, buffer = bufnr})
end

return attachableBindings
