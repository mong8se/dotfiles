local g = vim.g

require('Comment').setup()

vim.notify = require("notify")

require('leap').set_default_keymaps()
require('mini.surround').setup()

MiniMap = require('mini.map')
MiniMap.setup({
    integrations = {MiniMap.gen_integration.gitsigns()},
    symbols = {
        encode = MiniMap.gen_encode_symbols.dot("4x2"),
        scroll_line = '╞',
        scroll_view = '│'
    },
    window = {width = 16, winblend = 40}
})

require('telescope').setup {
    defaults = {path_display = {"smart"}},
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}

require('telescope').load_extension('fzf')

-- Setup nvim-cmp.
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                          mode, true)
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
        end
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        ['<CR>'] = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, {"i", "s"})
    },
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'vsnip'} -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {{name = 'buffer'}})
})

-- opt.configuration='for specific filetype.'
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        {name = 'cmp_git'} -- You can specify the `cmp_git` source if you were installed it.
    }, {{name = 'buffer'}})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
    require'illuminate'.on_attach(client)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    require("keys").lsp(bufnr)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    {'tsserver', 'package.json'}, {'denols', 'deps.ts', 'deps.js'}, 'html',
    "cssls", "jsonls", "gopls", "rust_analyzer", "sumneko_lua"
}
for _, cnf in pairs(servers) do
    local server_config = {
        on_attach = lsp_on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150
        }
    }

    local lsp
    if type(cnf) == "table" then
        lsp = table.remove(cnf, 1)
        server_config["root_dir"] = require('lspconfig.util').root_pattern(
                                        unpack(cnf))
    else
        lsp = cnf
    end

    require('lspconfig')[lsp].setup(server_config)
end

require'nvim-treesitter.configs'.setup {
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
                ["ic"] = "@class.inner"
            }
        },
        swap = {
            enable = true,
            swap_next = {["]a"] = "@parameter.inner"},
            swap_previous = {["[a"] = "@parameter.inner"}
        }
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
        additional_vim_regex_highlighting = false
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    indent = {enable = true}
}

require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}

require'lualine'.setup {
    options = {
        theme = vim.startswith(g.colors_name, "base16") and "base16" or
            "gruvbox-material",

        section_separators = {left = '', right = ''},
        component_separators = {left = '', right = ''}

    }
}

require("indent_blankline").setup {
    show_current_context = true,
    buftype_exclude = {"terminal"}
}

-- dashboard-nvim
g.dashboard_default_executive = 'telescope'

-- Pair expansion is dot-repeatable by default:
g.pear_tree_repeatable_expand = 0

-- Smart pairs are disabled by default:
g.pear_tree_smart_openers = 1
g.pear_tree_smart_closers = 1
g.pear_tree_smart_backspace = 1
g.pear_tree_ft_disabled = {'TelescopePrompt'}

-- CtrlSF
g.ctrlsf_default_root = 'project' -- search relative to project root
g.ctrlsf_ackprg = vim.fn.executable('/usr/local/bin/rg') == 1 and
                      '/usr/local/bin/rg' or '/usr/bin/rg'

-- search

-- Golden Ratio
g.golden_ratio_autocommand = 0

-- compare to <C-W>=

-- vim-sneak
g['sneak#streak'] = 1

g.indentLine_char = "⡇"

-- lir
local actions = require 'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require 'lir.clipboard.actions'

require'lir'.setup {
    show_hidden_files = false,
    devicons_enable = true,
    mappings = {
        ['<CR>'] = actions.edit,
        ['<C-s>'] = actions.split,
        ['<C-v>'] = actions.vsplit,
        ['<C-t>'] = actions.tabedit,

        ['-'] = actions.up,
        ['gq'] = actions.quit,

        ['K'] = actions.mkdir,
        ['N'] = actions.newfile,
        ['R'] = actions.rename,
        ['@'] = actions.cd,
        ['Y'] = actions.yank_path,
        ['.'] = actions.toggle_show_hidden,
        ['D'] = actions.delete,
        ['J'] = function()
            mark_actions.toggle_mark()
            vim.cmd('normal! j')
        end,
        ['C'] = clipboard_actions.copy,
        ['X'] = clipboard_actions.cut,
        ['P'] = clipboard_actions.paste
    },
    hide_cursor = true,
    on_init = function()
        -- use visual mode
        vim.api.nvim_buf_set_keymap(0, "x", "J",
                                    ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
                                    {noremap = true, silent = true})

        -- echo cwd
        vim.api.nvim_echo({{vim.fn.expand("%:p"), "Normal"}}, false, {})
    end
}

require('gitsigns').setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        require("keys").gitsigns(gs, bufnr)
    end
}

require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}
