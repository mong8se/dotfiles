local shiftwidth = 2
vim.bo.shiftwidth = shiftwidth

-- cargo install stylua
vim.bo.formatprg = "stylua --verify --syntax=Lua51 --sort-requires --column-width=80 --indent-type=Spaces --line-endings=Unix --quote-style=AutoPreferDouble --collapse-simple-statement=Always --indent-width="
  .. shiftwidth
  .. " -"
