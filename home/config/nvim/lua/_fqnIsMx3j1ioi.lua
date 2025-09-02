vim.g.jsx_ext_required = 0

-- copilot
vim.keymap.set("i", "<right>", 'copilot#Accept("\\<right>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
  ["*"] = true,
  ["grug-far"] = false,
  ["grug-far-history"] = false,
  ["grug-far-help"] = false,
}
