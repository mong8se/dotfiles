local combinedTargets = {
  "@assignment.inner", "@assignment.lhs", "@assignment.outer",
  "@assignment.rhs", "@attribute.inner", "@attribute.outer", -- "@block.inner",
  "@block.outer", "@call.inner", "@call.outer", "@class.inner", "@class.outer",
  -- "@comment.inner",
  -- "@comment.outer",
  "@conditional.inner", "@conditional.outer", "@frame.inner", "@frame.outer",
  "@function.inner", "@function.outer", "@loop.inner", "@loop.outer",
  "@number.inner", "@parameter.inner", -- "@parameter.outer",
  -- "@regex.inner",
  "@regex.outer", "@return.inner", "@return.outer", "@scopename.inner",
  "@statement.outer"
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdateSync',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "bash", "dockerfile", "go", "lua", "rust", "css", "diff", "elvish",
          "fish", "git_config", "git_rebase", "gitcommit", "gitignore",
          "graphql", "groovy", "html", "http", "java", "javascript", "jq",
          "jsdoc", "json", "kotlin", "make", "markdown", "markdown_inline",
          "mermaid", "python", "regex", "ruby", "scss", "sql", "svelte",
          "todotxt", "toml", "tsx", "typescript", "yaml"
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
              ["]z"] = {
                query = "@fold",
                query_group = "folds",
                desc = "Fold next"
              }
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = {query = combinedTargets}
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = {query = combinedTargets},
              ["[z"] = {
                query = "@fold",
                query_group = "folds",
                desc = "Fold last"
              }
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
        indent = {enable = true},
        matchup = {
          enable = true,
        },
      }
    end
  }, 'nvim-treesitter/nvim-treesitter-textobjects'
}
