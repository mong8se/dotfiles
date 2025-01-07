-- Use lsp for these
vim.g.polyglot_disabled = {
  "css", "sensible", "go", "html", "javascript", "json", "lua", "python",
  "rust", "typescript"
}

-- Golden Ratio
vim.g.golden_ratio_autocommand = 0

local disabled_built_ins = {
  "getscript", "logipat", "2html_plugin", "getscriptPlugin", "matchit", "netrw",
  "netrwPlugin", "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin"
}

for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugs")
