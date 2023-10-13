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
  tab = "╍╍⇥",
  trail = "ˍ",
  precedes = "\\uf053",
  extends = "\\uf054"
}

settings.fillchars = {
  eob = "⢎",
  horiz = "═",
  vert = "▕",
  fold = "╍",
  foldopen = "\\uf078",
  foldclose = "\\uf077"
}

settings.lazyredraw = true
settings.ttyfast = true

settings.splitright = true
settings.splitbelow = true

settings.undofile = true

settings.foldmethod = "expr"
settings.foldexpr = "nvim_treesitter#foldexpr()"
settings.foldlevelstart = 4
settings.foldtext = "v:lua.Mong8seFoldIt()"
function Mong8seFoldIt()
  return string.format("%s …%i… %s", vim.fn.getline(vim.v.foldstart),
                       (vim.v.foldend - vim.v.foldstart - 1),
                       vim.fn.getline(vim.v.foldend):gsub("^%s*", ""))
end

if has("spell") then vim.o.spelllang = "en_us" end

if has("user_commands") then
  command("Q", "q<bang>", {bang = true})
  command("QA", "qa<bang>", {bang = true})
  command("Qa", "qa<bang>", {bang = true})

  command("Split", splitCommand, {nargs = "?", complete = "file"})
  -- This is to override split to be our new Split.
  -- Since command abbr also effects search,
  -- we want to make sure we are in ex mode (:)
  cmd(
      "cnoreabbrev <expr> split getcmdtype() == ':' && getcmdline() ==# 'split' ? 'Split' : 'split'")
end

settings.grepprg = 'rg\\ --vimgrep\\ --no-heading\\ --smart-case'
