local global = vim.g
local bind = vim.keymap.set
local has = vim.fn.has

local remap = { remap = true }

global.mapleader = " "

-- Move lines
bind("i", "<C-j>", "<ESC>:m .+1<CR>==gi")
bind("i", "<C-k>", "<ESC>:m .-2<CR>==gi")
bind("v", "<C-j>", ":m '>+1<CR>gv=gv")
bind("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- I can type :help on my own, thanks.
bind("n", "<F1>", "<Nop>")

-- C-\ collides with abduco
bind("t", "<C-w><C-w>", "<C-\\><C-n>")

-- Map Y to act like D and C, i.e. to yank until EOL,
-- rather than act as yy, which is the default
bind("n", "Y", "y$")

-- Map U to redo
bind("n", "U", "<C-r>")

-- Instead of look up in man, let"s split, opposite of J for join
bind("n", "K", "i<CR><Esc>")

-- Map <C-L> (redraw screen) to also turn off search highlighting until the
-- next search
bind("n", "<C-L>", ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>", { silent = true })

-- Arrow keys move up and down visible lines, not physical lines
bind("n", "<Down>", "gj")
bind("n", "<Up>", "gk")

-- scroll up and down without moving cursor line
bind("n", "<C-k>", "<C-e>gk")
bind("n", "<C-j>", "<C-y>gj")

-- Make shift + arrow work more like other editors, selecting text
bind("n", "<S-Up>", "v<Up>", remap)
bind("n", "<S-Down>", "v<Down>", remap)
bind("n", "<S-Left>", "v<Left>", remap)
bind("n", "<S-Right>", "v<Right>", remap)
bind("v", "<S-Up>", "<Up>", remap)
bind("v", "<S-Down>", "<Down>", remap)
bind("v", "<S-Left>", "<Left>", remap)
bind("v", "<S-Right>", "<Right>", remap)
bind("i", "<S-Up>", "<Esc>v<Up>", remap)
bind("i", "<S-Down>", "<Esc>v<Down>", remap)
bind("i", "<S-Left>", "<Esc>v<Left>", remap)
bind("i", "<S-Right>", "<Esc>v<Right>", remap)

-- Original mapping
bind("n", "Q", "gq")

-- reselect the text that was just pasted so I can perform commands (like indentation) on it:
bind("n", "<expr>", "gp '`[' . strpart(getregtype(), 0, 1) . '`]'")

-- visual shifting (does not exit Visual mode)
bind("v", "<", "<gv")
bind("v", ">", ">gv")

-- custom functions
bind("n", "<Leader>tn", function()
  require("mong8se").toggleNumberMode()
end, { remap=true, silent = true })

bind("n", "<Leader>tb",function()
  require("mong8se").toggleScrollBindAllWindows()
end, { silent = true })

bind("n", "<Leader>tc", ":Telescope colorscheme<cr>", { silent = true })

-- Trouble
bind("n", "<leader>tt", "<cmd>TroubleToggle<cr>")
bind("n", "<leader>tw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>")
bind("n", "<leader>td", "<cmd>TroubleToggle lsp_document_diagnostics<cr>")
bind("n", "<leader>tq", "<cmd>TroubleToggle quickfix<cr>")
bind("n", "<leader>tl", "<cmd>TroubleToggle loclist<cr>")
bind("n", "gR", "<cmd>TroubleToggle lsp_references<cr>")

bind("n", "[<cr>", ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[")
bind("n", "]<cr>", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>")

if has("spell") then
  vim.o.spelllang = "en_us"
  bind('n', '<silent>', '<Leader>ts :setlocal spell!<CR>')
end

-- tabs
bind('n', ']t', ':tabnext<CR>', {remap = true, silent = true})
bind('n', '[t', ':tabprevious<CR>', {remap = true, silent = true})

-- insert
bind('n', '<Leader>ir', ':Telescope registers<CR>',
     {remap = true, silent = true})

-- lir
bind('n', '<Leader>ff', ':edit .<cr>', {remap = true, silent = true})
bind('n', '<Leader>f-', function()
    vim.cmd("edit " .. require("mong8se").directoryFromContext())
end, {remap = true, silent = true})

-- buffers
bind('n', ']b', ':bn<CR>', {remap = true, silent = true})
bind('n', '[b', ':bp<CR>', {remap = true, silent = true})
bind('n', '<Leader><space>', function()
    require'telescope.builtin'.buffers {
        sort_lastused = 1,
        ignore_current_buffer = 1
    }
end)
