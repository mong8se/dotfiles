local g = vim.g
local attachableBindings = require("keys")

vim.notify = require("notify")

require('mini.bracketed').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.jump').setup()
require('mini.pairs').setup()
require('mini.starter').setup()

require('lualine').setup()
require('mini.surround').setup()

local MiniIcons = require('mini.icons')
MiniIcons.setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.diff").setup({
  view = {signs = {add = '🮌', change = '🮌', delete = '🮌'}}
})

vim.cmd.highlight("MiniDiffSignAdd", 'guifg=#00ddff')
vim.cmd.highlight("MiniDiffSignChange", 'guifg=#ff9900')
vim.cmd.highlight("MiniDiffSignDelete", 'guifg=#dd00dd')

local jump2d = require('mini.jump2d')
local jump_line_start = jump2d.builtin_opts.word_start
jump2d.setup({spotter = jump_line_start.spotter})

local MiniMap = require('mini.map')
MiniMap.setup({
  integrations = {MiniMap.gen_integration.diff()},
  symbols = {
    encode = MiniMap.gen_encode_symbols.dot("4x2"),
    scroll_line = '▐',
    scroll_view = '│'
  },
  window = {width = 16, winblend = 70}
})

-- Setup nvim-cmp.
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
             vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
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
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
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
    end, {"i", "s"}),
    ['<C-\\>'] = cmp.mapping(function(fallback)
      vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api
                                                         .nvim_replace_termcodes(
                                                         '<Tab>', true, true,
                                                         true)), 'n', true)
    end)
  },
  experimental = {
    ghost_text = false -- this feature conflict with copilot.vim's preview.
  },
  sources = cmp.config.sources({
    {name = 'nvim_lsp'}, {name = 'vsnip'} -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {{name = 'buffer'}}),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  }
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

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  {'ts_ls', root_pattern = {'package.json'}},
  {'denols', root_pattern = {'deps.ts', 'deps.js'}}, 'html', "cssls", "jsonls",
  "pylsp", "gopls", "rust_analyzer", "lua_ls"
}
for _, cnf in pairs(servers) do
  local server_config = {}

  local lsp
  if type(cnf) == "table" then
    lsp = table.remove(cnf, 1)

    if cnf.root_pattern then
      server_config.root_dir = require('lspconfig.util').root_pattern(unpack(
                                                                          cnf.root_pattern))
    end

    if cnf.settings then server_config.settings = cnf.settings end
  else
    lsp = cnf
  end

  require('lspconfig')[lsp].setup(server_config)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    attachableBindings.lsp(vim.lsp, ev.buf)
  end,
})

local combinedTargets = {
  "@assignment.inner", "@assignment.lhs", "@assignment.outer",
  "@assignment.rhs", "@attribute.inner", "@attribute.outer",
  -- "@block.inner",
  "@block.outer", "@call.inner", "@call.outer", "@class.inner", "@class.outer",
  -- "@comment.inner",
  -- "@comment.outer",
  "@conditional.inner", "@conditional.outer", "@frame.inner", "@frame.outer",
  "@function.inner", "@function.outer", "@loop.inner", "@loop.outer",
  "@number.inner", "@parameter.inner",
  -- "@parameter.outer",
  -- "@regex.inner",
  "@regex.outer",
  "@return.inner", "@return.outer",
  "@scopename.inner", "@statement.outer"
}
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash", "dockerfile", "go", "lua", "rust", "css", "diff", "elvish", "fish",
    "git_config", "git_rebase", "gitcommit", "gitignore", "graphql", "groovy",
    "html", "http", "java", "javascript", "jq", "jsdoc", "json", "kotlin",
    "make", "markdown", "markdown_inline", "mermaid", "python", "regex", "ruby",
    "scss", "sql", "svelte", "todotxt", "toml", "tsx", "typescript", "yaml"
  },
  auto_install = true,
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
        -- a for argument
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",

        ["ar"] = "@regex.outer",
        ["ir"] = "@regex.inner"
      }
    },
    swap = {
      enable = true,
      swap_next = {["]a"] = "@parameter.inner"},
      swap_previous = {["[a"] = "@parameter.inner"}
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = {query = combinedTargets},
        ["]z"] = {query = "@fold", query_group = "folds", desc = "Fold next"}
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = {query = combinedTargets}
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = {query = combinedTargets},
        ["[z"] = {query = "@fold", query_group = "folds", desc = "Fold last"}
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = {query = combinedTargets}
      }
    }
  },
  highlight = {enable = true, additional_vim_regex_highlighting = false},
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

require("trouble").setup()

require("ibl").setup({indent = {char = "▏"}})

require("oil").setup()
