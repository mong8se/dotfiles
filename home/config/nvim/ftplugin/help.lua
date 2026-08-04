-- make q in normal mode in a help file close the help

vim.keymap.set("n", "q", ":helpclose<CR>", {
  remap = true,
  silent = true,
  buffer = true,
})

-- open help in a vertical split
vim.cmd.wincmd("L")
