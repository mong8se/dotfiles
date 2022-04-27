local g = vim.g
local settings = vim.o
local bind = vim.keymap.set
local remap = { remap = true }

vim.notify = require("notify")

require('telescope').setup {
  defaults = {
    path_display = {
      smart = 1,
      truncate = 3
    }
  }
}

-- Setup nvim-cmp.
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require 'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- opt.configuration='for specific filetype.'
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
bind('n', '<leader>e', function()
  vim.diagnostic.open_float()
end, opts)
bind('n', '[d', function()
  vim.diagnostic.goto_prev()
end, opts)
bind('n', ']d', function()
  vim.diagnostic.goto_next()
end, opts)
bind('n', '<leader>q', function()
  vim.diagnostic.setloclist()
end, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require 'illuminate'.on_attach(client)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  { 'tsserver', 'package.json' },
  { 'denols', 'deps.ts', 'deps.js' },
  'html', "cssls", "jsonls", "gopls", "rust_analyzer", "sumneko_lua"
}
for _, cnf in pairs(servers) do
  local server_config = {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }

  local lsp
  if type(cnf) == "table" then
    lsp = table.remove(cnf, 1)
    server_config["root_dir"] = require('lspconfig.util').root_pattern(unpack(cnf))
  else
    lsp = cnf
  end

  require('lspconfig')[lsp].setup(server_config)
end

require 'treesitter-context'.setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  throttle = true, -- Throttles plugin updates (may improve performance)
}

require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["]a"] = "@parameter.inner",
      },
      swap_previous = {
        ["[a"] = "@parameter.inner",
      },
    },
  },
  highlight = {
    enable = true,
    -- custom_captures = {
    -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    -- ["foo.bar"] = "Identifier",
    -- },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- opt.this='to `true` if you depend on 'syntax' being enabled (like for indentation).'
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  indent = {
    enable = true
  }
}

require("trouble").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

require 'lualine'.setup {
  options = { theme = 'wombat' }
}

require("bufferline").setup {}

require("indent_blankline").setup {
  show_current_context = true,
  buftype_exclude = { "terminal" }
}

-- dashboard-nvim
g.dashboard_default_executive = 'telescope'

-- Pair expansion is dot-repeatable by default:
g.pear_tree_repeatable_expand = 0

-- Smart pairs are disabled by default:
g.pear_tree_smart_openers = 1
g.pear_tree_smart_closers = 1
g.pear_tree_smart_backspace = 1
g.pear_tree_ft_disabled = { 'TelescopePrompt' }

-- Fugitive
bind('n', '<leader>gs', ':Gstatus<cr>', { remap = true, silent = true })
bind('n', '<leader>gc', ':Gcommit<cr>', { remap = true, silent = true })
bind('n', '<leader>gl', ':Gclog<cr>', { remap = true, silent = true })
bind('n', '<leader>gd', ':Gdiff<cr>', { remap = true, silent = true })
bind('n', '<leader>gb', ':Telescope git_branches<cr>', { remap = true, silent = true })

-- vim-signify
g.signify_vcs_list = { 'git' }
g.signify_realtime = 1
bind('n', '<Leader>gt', ':SignifyToggle<CR>', { remap = true, silent = true })
bind('n', '<leader>gh', ':SignifyToggleHighlight<CR>', { remap = true, silent = true })
bind('n', '<leader>gf', ':SignifyFold<CR>', { remap = true, silent = true })
bind('n', '<leader>gr', ':SignifyRefresh<CR>', { remap = true, silent = true })


-- So signs and number share a column when numbers are on
settings.signcolumn = 'number'
settings.showtabline = 2

-- CtrlSF
bind('n', '<leader>/', '<Plug>CtrlSFPrompt', remap)
bind('n', '<leader>*', '<Plug>CtrlSFCwordExec', remap)
bind('v', '<leader>/', '<Plug>CtrlSFVwordExec', remap)
bind('n', '<leader>sr', ':CtrlSFOpen<CR>', { remap = true, silent = true })
g.ctrlsf_default_root = 'project' -- search relative to project root
g.ctrlsf_ackprg = vim.fn.executable('/usr/local/bin/rg') and '/usr/local/bin/rg' or '/usr/bin/rg'


bind('n', '<Leader>p', function()
  require("mong8se").activateGitOrFiles()
end, { remap = true, silent = true })

bind('n', '<Leader>pf', ':Telescope find_files<CR>', { remap = true, silent = true })

bind('n', '<Leader>:', ':Telescope commands<CR>', { remap = true, silent = true })

-- search
bind('n', '<Leader>sp', ':Telescope live_grep<CR>', { remap = true, silent = true })
bind('n', '<Leader>sh', ':Telescope search_history<CR>', { remap = true, silent = true })
bind('n', '<Leader>sb', ':Telescope current_buffer_fuzzy_find<CR>', { remap = true, silent = true })

-- code
bind('n', '<Leader>c/', ':Telescope lsp_references<CR>', { remap = true, silent = true })
bind('n', '<Leader>cj', ':Telescope lsp_document_symbols<CR>', { remap = true, silent = true })
bind('n', '<Leader>cJ', ':Telescope lsp_dynamic_workspace_symbols<CR>', { remap = true, silent = true })
bind('n', '<Leader>ca', ':Telescope lsp_code_actions<CR>', { remap = true, silent = true })
bind('n', '<Leader>ct', ':Telescope treesitter<CR>', { remap = true, silent = true })
bind('n', '<Leader>cr', function()
  vim.lsp.buf.rename()
end, { remap = true, silent = true })
bind('n', '<Leader>ce', function()
  vim.lsp.diagnostic.show_line_diagnostics()
end, { remap = true, silent = true })
bind('n', '<Leader>cz', function()
  vim.lsp.buf.type_definition()
end, { remap = true, silent = true })

-- insert
bind('n', '<Leader>ir', ':Telescope registers<CR>', { remap = true, silent = true })

bind('n', '[e', function()
  vim.lsp.diagnostic.goto_prev()
end, { remap = true, silent = true })
bind('n', ']e', function()
  vim.lsp.diagnostic.goto_next()
end, { remap = true, silent = true })

-- Dirvish
bind('n', '<Leader>ff', ':Dirvish<CR>', { remap = true, silent = true })
bind('n', '<Leader>f-', '<Plug>(dirvish_up)', { remap = true, silent = true })

-- buffers
bind('n', ']b', ':bn<CR>', { remap = true, silent = true })
bind('n', '[b', ':bp<CR>', { remap = true, silent = true })
bind('n', '<Leader><space>', function()
  require 'telescope.builtin'.buffers { sort_lastused = 1, ignore_current_buffer = 1 }
end)

-- tabs
bind('n', ']t', ':tabnext<CR>', { remap = true, silent = true })
bind('n', '[t', ':tabprevious<CR>', { remap = true, silent = true })

-- Golden Ratio
g.golden_ratio_autocommand = 0
bind('n', '<leader>tg', '<Plug>(golden_ratio_toggle)', { remap = true, silent = true })
-- compare to <C-W>=
bind('n', '<C-W>\\', '<Plug>(golden_ratio_resize)', { remap = true, silent = true })

-- vim-sneak
g['sneak#streak'] = 1

g.indentLine_char = "⡇"

bind("n", "<leader>xx", "<cmd>Trouble<cr>",
  { silent = true, noremap = true }
)
bind("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  { silent = true, noremap = true }
)
bind("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  { silent = true, noremap = true }
)
bind("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  { silent = true, noremap = true }
)
bind("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  { silent = true, noremap = true }
)
bind("n", "gR", "<cmd>Trouble lsp_references<cr>",
  { silent = true, noremap = true }
)
