local signs = {
  add = {
    text = "🮌",
  },
  change = {
    text = "🮌",
  },
  changedelete = {
    text = "🮌",
  },
  untracked = {
    text = "🮌",
  },
}

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {

      signs = signs,
      signs_staged = signs,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local setKeyMap = vim.keymap.set

        -- h for hunk
        setKeyMap("n", "]h", gs.next_hunk, {
          desc = "Hunk forward",
          buffer = bufnr,
        })
        setKeyMap("n", "[h", gs.prev_hunk, {
          desc = "Hunk last",
          buffer = bufnr,
        })

        -- Actions
        setKeyMap("n", "<leader>hs", gs.stage_hunk, {
          buffer = bufnr,
          desc = "Stage hunk",
        })
        setKeyMap("n", "<leader>hr", gs.reset_hunk, {
          buffer = bufnr,
          desc = "Reset hunk",
        })
        setKeyMap(
          "v",
          "<leader>hs",
          function()
            gs.stage_hunk({
              vim.fn.line("."),
              vim.fn.line("v"),
            })
          end,
          {
            buffer = bufnr,
            desc = "Stage Hunk",
          }
        )
        setKeyMap(
          "v",
          "<leader>hr",
          function()
            gs.reset_hunk({
              vim.fn.line("."),
              vim.fn.line("v"),
            })
          end,
          {
            buffer = bufnr,
            desc = "Reset hunk",
          }
        )
        setKeyMap("n", "<leader>hS", gs.stage_buffer, {
          buffer = bufnr,
          desc = "Stage buffer",
        })
        setKeyMap("n", "<leader>hR", gs.reset_buffer, {
          buffer = bufnr,
          desc = "Reset buffer",
        })
        setKeyMap("n", "<leader>hp", gs.preview_hunk, {
          buffer = bufnr,
          desc = "Preview hunk",
        })
        setKeyMap(
          "n",
          "<leader>hb",
          function()
            gs.blame_line({
              full = true,
            })
          end,
          {
            buffer = bufnr,
            desc = "Blame hunk",
          }
        )
        setKeyMap("n", "<leader>tgb", gs.toggle_current_line_blame, {
          buffer = bufnr,
          desc = "Toggle git blame line",
        })
        setKeyMap("n", "<leader>hd", gs.diffthis, {
          buffer = bufnr,
          desc = "Hunk diff",
        })
        setKeyMap("n", "<leader>hD", function() gs.diffthis("~") end, {
          buffer = bufnr,
          desc = "Diff what",
        })
        setKeyMap("n", "<leader>tgd", gs.toggle_deleted, {
          buffer = bufnr,
          desc = "Toggle git deleted lines",
        })

        -- Text object
        setKeyMap(
          {
            "o",
            "x",
          },
          "ih",
          ":<C-U>Gitsigns select_hunk<CR>",
          {
            buffer = bufnr,
          }
        )
      end,
    },
  },
}
