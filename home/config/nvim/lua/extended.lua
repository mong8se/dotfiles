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

local jump2d = require('mini.jump2d')
local jump_line_start = jump2d.builtin_opts.word_start
jump2d.setup({spotter = jump_line_start.spotter})

local MiniMap = require('mini.map')
MiniMap.setup({
  integrations = {MiniMap.gen_integration.gitsigns()},
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

require('gitsigns').setup {
  signs = {
    add = {text = '🮌'},
    change = {text = '🮌'},
    changedelete = {text = '🮌'},
    untracked = {text = '🮌'}
  },
  signs_staged = {
    add = {text = '🮌'},
    change = {text = '🮌'},
    changedelete = {text = '🮌'},
    untracked = {text = '🮌'}
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    attachableBindings.gitsigns(gs, bufnr)
  end
}

require("oil").setup()
