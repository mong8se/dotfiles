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
        ["grug-far"] = false,
        ["grug-far-history"] = false,
        ["grug-far-help"] = false,
        ["oil"] = false,
        ["vimwiki"] = false,
      }
      vim.keymap.set("i", "<right>", 'copilot#Accept("\\<right>")', {
        expr = true,
        replace_keycodes = false,
      })
    end,
  },
}
