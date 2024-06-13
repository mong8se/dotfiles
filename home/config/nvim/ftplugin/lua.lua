local shiftwidth = 2
vim.bo.shiftwidth = shiftwidth
vim.bo.formatprg = 'lua-format --indent-width=' .. shiftwidth
