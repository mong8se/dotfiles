vim.bo.shiftwidth = 2
vim.bo.textwidth = 80
vim.bo.expandtab = true

-- cargo install stylua
vim.bo.formatprg = string.format(
  "stylua --verify --syntax=Lua51 --sort-requires --indent-type=%s --quote-style=AutoPreferDouble --collapse-simple-statement=Always --indent-width=%s --column-width=%s -",
  not vim.bo.expandtab and "Tabs" or "Spaces",
  vim.bo.shiftwidth,
  vim.bo.textwidth
)
