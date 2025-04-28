return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    -- use a release tag to download pre-built binaries
    version = "*",
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
      keymap = {
        preset = "super-tab",
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        menu = {
          border = "rounded",
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },

      -- Experimental: Adds a signature help provider for LSP servers that support it
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
    },
    opts_extend = {
      "sources.default",
    },
  },

  -- LSP servers and clients communicate which features they support through "capabilities".
  --  By default, Neovim supports a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in general for nvim-lspconfig:

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },

    -- example using `opts` for defining servers
    opts = {
      servers = {
        ts_ls = {
          root_pattern = {
            "package.json",
          },
        },
        denols = {
          root_pattern = {
            "deps.ts",
            "deps.js",
          },
        },
        html = {},
        cssls = {},
        jsonls = {},
        pylsp = {},
        gopls = {},
        rust_analyzer = {},
        lua_ls = {},
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      for server, config in pairs(opts.servers) do
        if config.root_pattern then
          config.root_dir =
            lspconfig.util.root_pattern(unpack(config.root_pattern))
        end

        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities =
          require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local setKeyMap = vim.keymap.set
          local lsp_buf = vim.lsp.buf
          local bufnr = ev.buf

          setKeyMap("n", "gD", lsp_buf.declaration, {
            silent = true,
            buffer = bufnr,
            desc = "Go to declaration",
          })
          setKeyMap("n", "gd", lsp_buf.definition, {
            silent = true,
            buffer = bufnr,
            desc = "Go to definition",
          })
          setKeyMap("n", "K", lsp_buf.hover, {
            silent = true,
            buffer = bufnr,
          })
          setKeyMap("n", "\\", lsp_buf.signature_help, {
            silent = true,
            buffer = bufnr,
          })
          setKeyMap("n", "<leader>wa", lsp_buf.add_workspace_folder, {
            silent = true,
            buffer = bufnr,
          })
          setKeyMap("n", "<leader>wr", lsp_buf.remove_workspace_folder, {
            silent = true,
            buffer = bufnr,
          })
          setKeyMap(
            "n",
            "<leader>wl",
            function() vim.print(lsp_buf.list_workspace_folders()) end,
            {
              silent = true,
              buffer = bufnr,
            }
          )
          setKeyMap("n", "<leader>cf", lsp_buf.format, {
            silent = true,
            buffer = bufnr,
            desc = "Format",
          })
          setKeyMap("n", "<leader>cr", lsp_buf.rename, {
            silent = true,
            buffer = bufnr,
            desc = "Rename",
          })
          setKeyMap("n", "<leader>cd", lsp_buf.type_definition, {
            silent = true,
            buffer = bufnr,
            desc = "Type definition",
          })

          setKeyMap(
            "n",
            "<leader>th",
            function(event)
              vim.lsp.inlay_hint.enable(
                event.buf,
                not vim.lsp.inlay_hint.is_enabled()
              )
            end,
            {
              desc = "Toggle inlay Hints",
            }
          )
        end,
      })
    end,
  },
}
