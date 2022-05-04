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
settings.timeoutlen = 1000
settings.ttimeout = true
settings.ttimeoutlen = 10

settings.wildmenu = true
settings.wildmode = "longest:full,full"

settings.wildignore:append("*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*")

settings.showcmd = true
settings.cmdheight = 2
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

settings.title = true
settings.scrolloff = 5
settings.wrap = false
settings.whichwrap = "<,>,b"
settings.sidescroll = 1
settings.sidescrolloff = 5
settings.virtualedit = "block,insert"

settings.list = true
settings.listchars = {
    tab = "╾╌",
    trail = "⎵",
    precedes = "⊲",
    extends = "⊳"
}
settings.fillchars = {vert = "│", fold = "╍"}

settings.lazyredraw = true
settings.ttyfast = true

settings.splitright = true
settings.splitbelow = true

settings.undofile = true

settings.foldlevelstart = 5
settings.foldmethod = "expr"
settings.foldexpr = require("nvim-treesitter").foldexpr

if has("clipboard") then settings.clipboard:prepend("unnamed") end

if has("user_commands") then
    command("Q", "q<bang>", {bang = true})
    command("QA", "qa<bang>", {bang = true})
    command("Qa", "qa<bang>", {bang = true})
    command("Split", splitCommand, {nargs = "*"})
    command("SPlit", splitCommand, {nargs = "*"})
end

settings.grepprg = 'rg\\ --vimgrep\\ --no-heading\\ --smart-case'

local disabled_built_ins = {
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "getscript",
    "getscriptPlugin", "vimball", "vimballPlugin", "2html_plugin", "logipat",
    "rrhelper", "spellfile_plugin", "matchit"
}

for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end
