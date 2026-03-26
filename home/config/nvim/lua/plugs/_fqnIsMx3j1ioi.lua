return {
  {
    "JamshedVesuna/vim-markdown-preview",
    ft = "markdown",
  },
  { "aklt/plantuml-syntax" },
  {
    "https://github.com/github/copilot.vim",
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["buffish"] = false,
        ["gitcommit"] = false,
        ["grug-far-help"] = false,
        ["grug-far-history"] = false,
        ["grug-far"] = false,
        ["help"] = false,
        ["oil"] = false,
        ["snacks_picker_input"] = false,
        ["vim"] = false,
        ["vimwiki"] = false,
      }

      vim.keymap.set("i", "<right>", 'copilot#Accept("\\<right>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.keymap.set("i", "<C-down>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-up>", "<Plug>(copilot-previous)")
    end,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim", branch = "master" },
  --   },
  --   build = "make tiktoken",
  --   opts = {
  --     -- See Configuration section for options
  --   },
  -- },
}
