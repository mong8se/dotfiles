local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use lsp for these
vim.g.polyglot_disabled = {
  "css", "go", "html", "javascript", "json", "lua", "rust", "sensible",
  "typescript"
}

-- Golden Ratio
vim.g.golden_ratio_autocommand = 0

local disabled_built_ins = {
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin", "2html_plugin",
  "logipat", "rrhelper", "spellfile_plugin", "matchit"
}

for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end

require("lazy").setup("plugs")
