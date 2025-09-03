-- Disable some built-in plugins
for _, plugin in pairs({
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "matchit",
  "netrw",
  "netrwPlugin",
  "spellfile_plugin",
}) do
  vim.g["loaded_" .. plugin] = 1
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      {
        "Failed to clone lazy.nvim:\n",
        "ErrorMsg",
      },
      {
        out,
        "WarningMsg",
      },
      {
        "\nPress any key to exit...",
      },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugs")
