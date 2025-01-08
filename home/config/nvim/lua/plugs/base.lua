return {
  'mong8se/actually.nvim',
  -- { dir = '~/Projects/actually.nvim'},

  'mong8se/buffish.nvim',
  -- { dir = '~/Projects/buffish.nvim' },

  {'stevearc/oil.nvim', opts = {}},
  'ibhagwan/fzf-lua',

  'stevearc/dressing.nvim', {
    'rcarriga/nvim-notify',
    config = function() vim.notify = require("notify") end
  },

  'RRethy/nvim-base16',
  'caglartoklu/borlandp.vim',
  'sainnhe/gruvbox-material',

  {'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {indent = {char = "▏"}}
  },

  {'folke/trouble.nvim', opts = {}},
  'roman/golden-ratio', -- C-W \
  'danilamihailov/beacon.nvim',

  {'lewis6991/gitsigns.nvim',
    opts = {

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
        local setKeyMap = vim.keymap.set

        -- h for hunk
        setKeyMap('n', ']h', gs.next_hunk,
                  {desc = "Hunk forward", buffer = bufnr})
        setKeyMap('n', '[h', gs.prev_hunk, {desc = "Hunk last", buffer = bufnr})

        -- Actions
        setKeyMap('n', '<leader>hs', gs.stage_hunk,
                  {buffer = bufnr, desc = "Stage hunk"})
        setKeyMap('n', '<leader>hr', gs.reset_hunk,
                  {buffer = bufnr, desc = "Reset hunk"})
        setKeyMap('v', '<leader>hs', function()
          gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
        end, {buffer = bufnr, desc = "Stage Hunk"})
        setKeyMap('v', '<leader>hr', function()
          gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
        end, {buffer = bufnr, desc = "Reset hunk"})
        setKeyMap('n', '<leader>hS', gs.stage_buffer,
                  {buffer = bufnr, desc = "Stage buffer"})
        setKeyMap('n', '<leader>hR', gs.reset_buffer,
                  {buffer = bufnr, desc = "Reset buffer"})
        setKeyMap('n', '<leader>hu', gs.undo_stage_hunk,
                  {buffer = bufnr, desc = 'Undo stage hunk'})
        setKeyMap('n', '<leader>hp', gs.preview_hunk,
                  {buffer = bufnr, desc = "Preview hunk"})
        setKeyMap('n', '<leader>hb', function()
          gs.blame_line {full = true}
        end, {buffer = bufnr, desc = "Blame hunk"})
        setKeyMap('n', '<leader>tgb', gs.toggle_current_line_blame,
                  {buffer = bufnr, desc = "Toggle git blame line"})
        setKeyMap('n', '<leader>hd', gs.diffthis,
                  {buffer = bufnr, desc = "Hunk diff"})
        setKeyMap('n', '<leader>hD', function() gs.diffthis('~') end,
                  {buffer = bufnr, desc = "Diff what"})
        setKeyMap('n', '<leader>tgd', gs.toggle_deleted,
                  {buffer = bufnr, desc = "Toggle git deleted lines"})

        -- Text object
        setKeyMap({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
                  {buffer = bufnr})
      end
    }
  },

  {'echasnovski/mini.nvim',
    dependencies = 'lewis6991/gitsigns.nvim',
    config = function()
      require('mini.bracketed').setup()
      require('mini.comment').setup()
      require('mini.cursorword').setup()
      require('mini.jump').setup()
      require('mini.pairs').setup()
      require('mini.starter').setup()

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
    end
  },

  {'nvim-lualine/lualine.nvim', opts = {}},
  'airblade/vim-rooter',
  'sheerun/vim-polyglot',

  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdateSync'},
  'nvim-treesitter/nvim-treesitter-textobjects',

  'dyng/ctrlsf.vim', -- leader /

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {preset = 'super-tab'},

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {default = {'lsp', 'path', 'snippets', 'buffer'}},

      -- Experimental: Adds a signature help provider for LSP servers that support it
      signature = {enabled = true, window = {border = "rounded"}}
    },
    opts_extend = {"sources.default"}
  },

  -- LSP servers and clients communicate which features they support through "capabilities".
  --  By default, Neovim supports a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in general for nvim-lspconfig:

  {
    'neovim/nvim-lspconfig',
    dependencies = {'saghen/blink.cmp'},

    -- example using `opts` for defining servers
    opts = {
      servers = {
        ts_ls = {root_pattern = {'package.json'}},
        denols = {root_pattern = {'deps.ts', 'deps.js'}},
        html = {},
        cssls = {},
        jsonls = {},
        pylsp = {},
        gopls = {},
        rust_analyzer = {},
        lua_ls = {}
      }
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require('blink.cmp').get_lsp_capabilities(
                                  config.capabilities)
        lspconfig[server].setup(config)
      end
    end
  },

  'tpope/vim-abolish', -- cr

  {'vimwiki/vimwiki',
    keys = {{'<leader>ww', '<Plug>VimwikiIndex', desc = 'Vimwiki Index'}}
  },

  {'itchyny/calendar.vim', cmd = 'Calendar'},

  {'mtth/scratch.vim', cmd = 'Scratch'} -- gs
}
