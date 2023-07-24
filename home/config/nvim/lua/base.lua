local cmd = vim.cmd
local settings = vim.opt
local command = vim.api.nvim_create_user_command
local has = vim.fn.has
local splitCommand = require("mong8se").splitCommand

cmd("syntax on")
settings.hidden = true

settings.hidden = true
settings.encoding = "utf-8"

settings.timeout = true
settings.timeoutlen = 750
settings.ttimeout = true
settings.ttimeoutlen = 10

settings.wildmenu = true
settings.wildmode = "longest:full,full"

settings.wildignore:append(
    "*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,node_modules/*")

settings.showcmd = true
settings.cmdheight = 1
settings.laststatus = 2

settings.mouse = "nvi"

settings.modelineexpr = false

settings.showmatch = true

settings.hlsearch = true
settings.incsearch = true
settings.inccommand = "nosplit"

settings.ignorecase = true
settings.smartcase = true

settings.backspace = "indent,eol,start"

settings.startofline = false

settings.ruler = true
settings.confirm = true
settings.visualbell = true

settings.pastetoggle = "<F11>"

settings.shiftwidth = 2
settings.softtabstop = 2
settings.expandtab = true
settings.autoindent = true
settings.smarttab = true

-- So signs and number share a column when numbers are on
settings.signcolumn = 'number'

settings.showtabline = 0

settings.title = true
settings.scrolloff = 5
settings.wrap = false
settings.whichwrap = "<,>,b"
settings.sidescroll = 1
settings.sidescrolloff = 5
settings.virtualedit = "block,insert"

settings.list = true
settings.listchars = {
  tab = "\\u26c1\\u26c0",
  trail = "\\u02cd",
  precedes = "\\uf053",
  extends = "\\uf054"
}
settings.fillchars = {
  vert = "│",
  fold = "╍",
  foldopen = "\\uf078",
  foldclose = "\\uf077"
}

settings.lazyredraw = true
settings.ttyfast = true

settings.splitright = true
settings.splitbelow = true

settings.undofile = true

settings.foldlevelstart = 5
settings.foldmethod = "expr"
settings.foldexpr = require("nvim-treesitter").foldexpr

if has("spell") then vim.o.spelllang = "en_us" end

if has("user_commands") then
  command("Q", "q<bang>", {bang = true})
  command("QA", "qa<bang>", {bang = true})
  command("Qa", "qa<bang>", {bang = true})
  command("Split", splitCommand, {nargs = "*"})
  command("SPlit", splitCommand, {nargs = "*"})
end

settings.grepprg = 'rg\\ --vimgrep\\ --no-heading\\ --smart-case'

vim.g.netrw_banner = false
vim.g.netrw_list_hide = "^\\.\\.\\?/$"

local disabled_built_ins = {
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin", "2html_plugin",
  "logipat", "rrhelper", "spellfile_plugin", "matchit"
}

for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end
