local mong8se = require("mong8se")
local register = require("which-key").register
local global = vim.g
local bind = vim.keymap.set
local has = vim.fn.has

global.mapleader = " "

register({
    f={
        name="file",
        ["-"]= {
            function() vim.cmd("edit " .. mong8se.directoryFromContext()) end, "Browse files from here", silent = true
        },
        f= { "Browse files from root of project" }
    },
    t={
        name="toggle",
        g={ '<Plug>(golden_ratio_toggle)', "Auto Golden Ratio Active Split", noremap = false},
        n={ mong8se.toggleNumberMode, "Toggle numbers", silent = true},
        b={ mong8se.toggleScrollBindAllWindows, "Scroll Bind All Windows" ,silent = true},
        c={ ":Telescope colorscheme<cr>", "Pick Color", silent = true},
        t={ "<cmd>TroubleToggle<cr>", "Toggle Trouble"},
        w={ "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
        d={ "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Document Diagnostics" },
        q={ "<cmd>TroubleToggle quickfix<cr>", "Trouble Quickfix" },
        l={ "<cmd>TroubleToggle loclist<cr>", "Trouble Loclist" },
        s={ "<cmd>setlocal spell!<CR>", "Toggle Spell Checking", silent=true}
    },
    c= {
        name="code",
        ["/"] = { ':Telescope lsp_references<CR>', "LSP References", silent = true},
        j = { ':Telescope lsp_document_symbols<CR>', "LSP Document Symbols", silent = true},
        J = { ':Telescope lsp_dynamic_workspace_symbols<CR>', "LSP Workspace Symbols", silent = true},
        a = { ':Telescope lsp_code_actions<CR>', "LSP Code Actions", silent = true},
        t = { ':Telescope treesitter<CR>', "Telescope Treesitter", silent = true},
        r = { function() vim.lsp.buf.rename() end, "LSP Rename", silent = true},
        z = { function() vim.lsp.buf.type_definition() end, "LSP Type Definition", silent = true}
    },
    p = {
        name="project",
        p= { mong8se.activateGitOrFiles, "Find files in project", silent = true},
        f= { ':Telescope find_files<CR>', "Find files", silent = true}
    },
    s = {
        name="search",
        r= { ':CtrlSFOpen<CR>', "Reopen CtrlSF", silent = true},
        p= { ':Telescope live_grep<CR>', "Telescope live grep", silent = true},
        h= { ':Telescope search_history<CR>', "Telescope search history", silent = true},
        b= { ':Telescope current_buffer_fuzzy_find<CR>', "Fuzzy search buffer", silent = true},
    },
    x = {
        name="trouble",
        x = { "<cmd>Trouble<cr>", "Open Trouble", silent = true},
        w = { "<cmd>Trouble workspace_diagnostics<cr>", "Trouble Workspace", silent = true},
        d = { "<cmd>Trouble document_diagnostics<cr>", "Trouble Document", silent = true},
        l = { "<cmd>Trouble loclist<cr>", "Trouble loclist", silent = true},
        q = { "<cmd>Trouble quickfix<cr>", "Trouble quickfix", silent = true},
        f = { function() vim.diagnostic.open_float() end, "Open Diagnostic Float", silent = true},
        q = { function() vim.diagnostic.setloclist() end, "Diagnostic loclist", silent = true},
    }
},
    { prefix = "<leader>"}
)

register({
    [" "] = { function()
        require'telescope.builtin'.buffers { sort_lastused = 1, ignore_current_buffer = 1 }
    end, "Buffers"
    },
    ["/"] = { '<Plug>CtrlSFPrompt', "CtrlSF", noremap=false},
    ["*"] = { '<Plug>CtrlSFCwordExec', "CtrlSF Search word"},
    [":"] = { ':Telescope commands<CR>', "Telescope a command", silent = true}
},
    { prefix = "<leader>"}
)

register({
    ["s"] = { mong8se.splitCommand, "Smart Split",  silent = true},
    ["<C-s>"] = { mong8se.splitCommand, "which_key_ignore", silent = true },
    ["\\"] = { '<Plug>(golden_ratio_resize)', "Resize to golden ratio", silent=true},
    ["<C-w>"] = {"<C-\\><C-n>", "Switch Window", mode = "t"}
},
    { prefix = "<c-w>"}
)

register({
    p= { [['`[' . strpart(getregtype(), 0, 1) . '`]']], "Select just pasted text", expr=true },
    R= { "<cmd>TroubleToggle lsp_references<cr>", "LSP References" },
    ["/"] = { mong8se.visualToSearch(), "Search selection via motion", silent = true},
},
    { prefix = "g"}
)

register({
    U={ "<C-r>", "Redo" },
    p = { 'p', "which_key_ignore" },
    ["pp"] = { '"+]p', "Paste from system clipboard after" },
    P = { 'p', "which_key_ignore" },
    ["PP"] = { '"+]P', "Paste from system clipboard before" },
    ["/"] = { mong8se.visualToSearch(), "Visual selection to search", mode = "v", silent = true},
    ["<f1>"] = { '<Nop>',"which_key_ignore"},
    Y= { 'y$', "which_key_ignore"},

    -- Instead of look up in man, let"s split, opposite of J for join
    K= {"i<CR><Esc>", "which_key_ignore"},
    ["<C-L>"] = { ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>", "which_key_ignore", silent = true },
    ["<Down>"] = { "gj", "which_key_ignore" },
    ["<Up>"] = { "gk", "which_key_ignore" },
    ["<C-k>"] = { "<C-e>gk", "which_key_ignore" },
    ["<C-j>"] = { "<C-y>gj", "which_key_ignore" },
    ["<S-Up>"] = { "v<Up>", "which_key_ignore" },
    ["<S-Down>"] = { "v<Down>", "which_key_ignore" },
    ["<S-Left>"] = { "v<Left>", "which_key_ignore" },
    ["<S-Right>"] = { "v<Right>", "which_key_ignore" },
    ["[d"] = { function() vim.diagnostic.goto_prev() end, "Previous Diagnostic", silent=true },
    ["]d"] = { function() vim.diagnostic.goto_next() end, "Next Diagnostic", silent=true },
    ["[<cr>"] = { ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[", "Make space above", silent=true },
    ["]<cr>"] = { ":<c-u>put =repeat(nr2char(10), v:count1)<cr>", "Make space below", silent=true },
    ["]t"] = { ':tabnext<CR>', "Next tab", silent=true },
    ["[t"] = { ':tabprevious<CR>', "Previous tab", silent=true },
    ["]b"] = { ':bn<CR>', "Next buffer", silent=true },
    ["[b"] = { ':bp<CR>', "Previous buffer", silent=true },
})

register({
    ["<C-j>"]= {"<ESC>:m .+1<CR>==gi", "Move line down", mode="i" },
    ["<C-k>"]= {"<ESC>:m .-2<CR>==gi", "Move line up", mode="i" },
    ["<S-Up>"] = { "<Esc>v<Up>", "which_key_ignore", mode="i" },
    ["<S-Down>"] = { "<Esc>v<Down>", "which_key_ignore", mode="i" },
    ["<S-Left>"] = { "<Esc>v<Left>", "which_key_ignore", mode="i" },
    ["<S-Right>"] = { "<Esc>v<Right>", "which_key_ignore", mode="i" }
})

register({
    ["<S-Up>"] = { "<Up>", "which_key_ignore", mode="v" },
    ["<S-Down>"] = { "<Down>", "which_key_ignore", mode="v" },
    ["<S-Left>"] = { "<Left>", "which_key_ignore", mode="v" },
    ["<S-Right>"] = { "<Right>", "which_key_ignore", mode="v" },
    ["<C-j>"]= {":m '>+1<CR>gv=gv", "Move line down", mode="v" },
    ["<C-k>"]= {":m '<-2<CR>gv=gv", "Move line up", mode="v" },
    ["<"] = { "<gv", "which_key_ignore", mode="v" },
    [">"] = { ">gv", "which_key_ignore", mode="v" },
})
