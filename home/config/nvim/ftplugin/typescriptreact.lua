vim.bo.formatprg = "npx prettier --parser=typescript"

vim.schedule(function()
  -- due to https://github.com/neovim/neovim/issues/13113 have to clear this
  vim.bo.formatexpr = ""
end)
