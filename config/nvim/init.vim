" Base config with vundle
runtime plugs.vim

syntax on

set hidden
set encoding=utf-8

set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value

set wildmenu
set wildmode=longest:full,full

set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/* "

set showcmd
set cmdheight=2
set laststatus=2

set mouse=nvi        " mouse for all
if ! has('nvim')
  set ttymouse=sgr   " mouse works past 223 columns
end

if exists('+modelineexpr')
  set nomodelineexpr
else
  " disable modelines if lacking above feature
  set modelines=0
  set nomodeline
end

set showmatch " show matching brackets

set hlsearch
set incsearch " show incremental search results
if has("inccommand")
  set inccommand=nosplit
end

set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

set ruler
set confirm
set visualbell

set pastetoggle=<F11>
au InsertLeave * set nopaste " Automatically leave paste mode when leaving insert mode

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smarttab

set title
set scrolloff=5
set nowrap
set whichwrap=<,>,b
set sidescroll=1
set sidescrolloff=5
set virtualedit=block,insert " allow cursor to go where there is nothing

set list listchars=tab:╾╌,trail:⎵,precedes:⊲,extends:⊳
set list fillchars=vert:│,fold:╍

" so complex operations dont display until finished
set lazyredraw
set ttyfast

set splitright " new vertical splits are to the right
set splitbelow " new horizontal splits are below

if has('persistent_undo')
  set undofile
endif

if ! has('nvim')
  " follow nvim more closely
  set viminfo='100,n$HOME/.local/share/vim/viminfo

  " Add matching plugin to super power %
  runtime! macros/matchit.vim
end

if has('nvim')
  set foldlevelstart=5
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
else
  set foldlevelstart=99
  set foldmethod=manual
end

if has('clipboard') && !exists("g:gui_oni")
  if has('unnamedplus')
    set clipboard^=unnamed,unnamedplus
  else
    set clipboard^=unnamed
  end
endif

" cursorline only for active window
augroup CursorLine
  autocmd!

  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup FocusIssues
  autocmd!

  " leave insert or replace mode
  autocmd BufEnter,WinLeave,FocusLost,VimSuspend * if empty(&buftype) | stopinsert | endif

  " Save the buffer if it is modified and has a filename
  autocmd BufLeave,FocusLost,VimSuspend * if !empty(@%) | update | endif
augroup END

"------------------------------------------------------------
" MAPPINGS

" Set <Leader> key
noremap <Space> <Nop>
let mapleader = "\<Space>"

" Move lines
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" I can type :help on my own, thanks.
noremap <F1> <Nop>
noremap! <F1> <Esc>

" C-\ collides with abduco
if exists(':tnoremap')
  tnoremap <C-w><C-w> <C-\><C-n>
endif

" q in normal mode in a help file closes the help
" similar to what happens in dirvish or fugitive
autocmd FileType help nmap <silent> <buffer> q :helpclose<CR>

" Map Y to act like D and C, i.e. to yank until EOL,
" rather than act as yy, which is the default
nnoremap Y y$

" Map U to redo
nnoremap U <C-r>

" Instead of look up in man, let's split, opposite of J for join
nnoremap K i<CR><Esc>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <silent> <C-L> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" Arrow keys move up and down visible lines, not physical lines
nnoremap <Down> gj
nnoremap <Up> gk

" scroll up and down without moving cursor line
nnoremap <C-k> <C-e>gj
nnoremap <C-j> <C-y>gk

" Make shift + arrow work more like other editors, selecting text
nmap <S-Up>    v<Up>
nmap <S-Down>  v<Down>
nmap <S-Left>  v<Left>
nmap <S-Right> v<Right>
vmap <S-Up>    <Up>
vmap <S-Down>  <Down>
vmap <S-Left>  <Left>
vmap <S-Right> <Right>
imap <S-Up>    <Esc>v<Up>
imap <S-Down>  <Esc>v<Down>
imap <S-Left>  <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

" Original mapping
nnoremap Q gq

" reselect the text that was just pasted so I can perform commands (like indentation) on it:
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" custom functions
nmap <silent> <Leader>tn <Plug>(mong8se_toggle_numbers)
nnoremap <silent> <Leader>tb <Plug>(mong8se_scrollbind)

nnoremap <silent> <Leader>tc :Telescope colorscheme<cr>

" Trouble
nnoremap <leader>tt <cmd>TroubleToggle<cr>
nnoremap <leader>tw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>td <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>tq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>tl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

nnoremap [<cr>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<cr>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

if has('spell')
  set spelllang=en_us
  nnoremap <silent> <Leader>ts :setlocal spell!<CR>
endif

if has("user_commands")
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>

  " Force saving files that require root permission
  command! Sudow w !sudo tee > /dev/null %
endif

"------------------------------------------------------------
" COLOR SCHEME

if has('nvim')
  set termguicolors
endif

if $BASE16_THEME != ""
  let base16colorspace=256
  colorscheme base16-$BASE16_THEME
else
  if $TERM_PROGRAM == "iTerm" && $ITERM_PROFILE == "light"
    set background=light
  else
    set background=dark
  endif

  let g:gruvbox_italic=1
  let g:gruvbox_contrast_dark="soft"
  let g:gruvbox_contrast_light="hard"
  let g:gruvbox_invert_selection=0
  let g:gruvbox_hls_cursor="fg0"
  if has('nvim')
    colorscheme gruvbox-flat
  else
    colorscheme gruvbox
  endif
endif

" need to install with `rake xterm-italic`
highlight Comment cterm=italic

"------------------------------------------------------------
" PLUGINS

let g:startify_custom_header =
      \ map(split(system('figlet -c -w $COLUMNS -f stampatello //'.mong8se#shortHostname()), '\n'), '"   ". v:val') + ['','']
let g:startify_list_order = [['// here'], 'dir', ['// anywhere'], 'files', ['// bookmarks'], 'bookmarks', ['// sessions'], 'sessions']
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')

" dashboard-nvim
let g:dashboard_default_executive ='telescope'

" Pair expansion is dot-repeatable by default:
let g:pear_tree_repeatable_expand = 0

" Smart pairs are disabled by default:
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_ft_disabled = ['TelescopePrompt']

" Fugitive
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>gc :Gcommit<cr>
nmap <silent> <leader>gl :Gclog<cr>
nmap <silent> <leader>gd :Gdiff<cr>
if has('nvim')
  nmap <silent> <leader>gb :Telescope git_branches<cr>
else
  nmap <silent> <leader>gb :Gbrowse<cr>
endif

" vim-signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime = 1
nmap <silent> <Leader>gt :SignifyToggle<CR>
nmap <silent> <leader>gh :SignifyToggleHighlight<CR>
nmap <silent> <leader>gf :SignifyFold<CR>
nmap <silent> <leader>gr :SignifyRefresh<CR>

" So signs and number share a column when numbers are on
set signcolumn=number

set showtabline=2

" CtrlSF
nmap     <leader>/ <Plug>CtrlSFPrompt
nmap     <leader>* <Plug>CtrlSFCwordExec
vmap     <leader>/ <Plug>CtrlSFVwordExec
nmap <silent> <leader>sr :CtrlSFOpen<CR>
let g:ctrlsf_default_root = 'project' " search relative to project root
let g:ctrlsf_ackprg = executable('/usr/local/bin/rg') ? '/usr/local/bin/rg' : '/usr/bin/rg'

" https://vim.fandom.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gVzv:call setreg('"', old_reg, old_regtype)<CR>

if has('nvim')
  nmap <silent> <Leader>p <Plug>(mong8se_p)
  nmap <silent> <Leader>pf :Telescope find_files<CR>

  nmap <silent> <Leader>: :Telescope commands<CR>
  " search
  nmap <silent> <Leader>sp :Telescope live_grep<CR>
  nmap <silent> <Leader>sh :Telescope search_history<CR>
  nmap <silent> <Leader>sb :Telescope current_buffer_fuzzy_find<CR>
  " code
  nmap <silent> <Leader>c/ :Telescope lsp_references<CR>
  nmap <silent> <Leader>cj :Telescope lsp_document_symbols<CR>
  nmap <silent> <Leader>cJ :Telescope lsp_dynamic_workspace_symbols<CR>
  nmap <silent> <Leader>ca :Telescope lsp_code_actions<CR>
  nmap <silent> <Leader>cd :Telescope lsp_definitions<CR>
  nmap <silent> <Leader>ci :Telescope lsp_implementations<CR>
  nmap <silent> <Leader>ct :Telescope treesitter<CR>
  nmap <silent> <Leader>cr :lua vim.lsp.buf.rename()<CR>
  nmap <silent> <Leader>ce :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  nmap <silent> <Leader>cz :lua vim.lsp.buf.type_definition()<CR>

  " insert
  nmap <silent> <Leader>ir :Telescope registers<CR>

  nmap <silent> [e :lua vim.lsp.diagnostic.goto_prev()<CR>
  nmap <silent> ]e :lua vim.lsp.diagnostic.goto_next()<CR>

else
  " FZF
  nnoremap <silent> <Leader>p :call mong8se#ActivateFZF()<CR>
  nnoremap <silent> <Leader>pf :Files<CR>
  nnoremap <silent> <Leader>: :Commands<CR>
  nnoremap <Leader>sp :Rg
  autocmd FileType fzf nmap <silent> <buffer> q :close<CR>
endif

" Ripgrep
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

" Dirvish
nmap <silent> <Leader>ff :Dirvish<CR>
nmap <silent> <Leader>f- <Plug>(dirvish_up)

" buffers
nmap <silent> ]b :bn<CR>
nmap <silent> [b :bp<CR>
if has('nvim')
  nnoremap <silent> <Leader><Space> :lua require'telescope.builtin'.buffers{sort_lastused=1, ignore_current_buffer=1}<CR>
else
  nnoremap <silent> <Leader><Space> :Buffers<CR>
endif

" tabs
nmap <silent> ]t :tabnext<CR>
nmap <silent> [t :tabprevious<CR>

" Golden Ratio
let g:golden_ratio_autocommand = 0
nmap <silent> <leader>tg <Plug>(golden_ratio_toggle)
" compare to <C-W>=
nmap <silent> <C-W>\ <Plug>(golden_ratio_resize)

" vim-sneak
let g:sneak#streak = 1

if has('nvim')

lua << EOF
require('telescope').setup{
defaults = {
  path_display={
    smart=1,
    truncate=3
  }
  }
}

 -- Setup nvim-cmp.
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.tsserver.setup{}
-- require'lspconfig'.denols.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.jsonls.setup{}
  require'lspconfig'.gopls.setup {
    on_attach = function(client)
      -- [[ other on_attach code ]]
      require 'illuminate'.on_attach(client)
    end,
  }

require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
    enable = true,

    -- Automatically jump forward to textobj, similar to targets.vim 
    lookahead = true,

    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      },
    },
  swap = {
    enable = true,
    swap_next = {
      ["]a"] = "@parameter.inner",
      },
    swap_previous = {
      ["[a"] = "@parameter.inner",
      },
    },
  },
    highlight = {
    enable = true,
    -- custom_captures = {
    -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    -- ["foo.bar"] = "Identifier",
    -- },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    },
  indent = {
  enable = true
  }
}

require("trouble").setup {
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
}


EOF

else
  " asyncomplete
  nmap <silent> ]e <Plug>(lsp-next-error)
  nmap <silent> [e <Plug>(lsp-previous-error)
  nmap <silent> ]w <Plug>(lsp-next-warning)
  nmap <silent> [w <Plug>(lsp-previous-warning)

  let g:asyncomplete_remove_duplicates = 1
  let g:asyncomplete_smart_completion = 1
  let g:asyncomplete_auto_popup = 1
  let g:lsp_signs_error = {'text': '✖'}
  let g:lsp_signs_hint = {'text': '✨'}
  let g:lsp_signs_information = {'text': 'ℹ'}
  let g:lsp_signs_warning = {'text': '‼'}

  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
endif

" Only show quick-scope highlights after f/F/t/T is pressed
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

" pretend these plugins are already loaded, so they don't load
let loaded_2html_plugin = 1
let loaded_matchparen   = 1
let loaded_netrw        = 1

" vim-illuminate
" hi illuminatedWord cterm=underline gui=underline

" indentLine
let g:indentLine_char = "⡇"

if has('nvim')
lua << EOF
  require'lualine'.setup{
    options = {theme = 'wombat'}
  }
  require("bufferline").setup{}

  require("indent_blankline").setup {
      show_current_context = true,
      buftype_exclude = {"terminal"}
  }
EOF
else
end

"------------------------------------------------------------
" LOCALS

call mong8se#LoadRCFiles()
