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

set foldlevelstart=99
set foldmethod=manual

if has('clipboard') && !exists("g:gui_oni")
  if has('x11') && version >= 703
    " Default yank and paste go to system clipboard
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif

" cursorline only for active window
augroup CursorLine
  autocmd!

  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup FocusIssues
  " Remove ALL autocommands for the current group.
  autocmd!

  " When focus is lost, leave insert or replace mode and
  " save the buffer if it is modified and has a filename
  autocmd BufLeave,FocusLost * if !empty(@%) | stopinsert | update | endif
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
nnoremap <silent> <Leader>tn :call mong8se#ToggleNumberMode()<CR>

nnoremap <silent> <Leader>tb :call mong8se#ScrollBindAllWindows()<CR>
nnoremap <silent> <leader>tc :Telescope colorscheme<cr>

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

" Crystalline
function! StatusLine(current, width)
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? '%#CrystallineFill# %{fugitive#head()} ' : '')
        \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
        \ . (a:width > 80 ? ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P ' : ' ')
endfunction

function! TabLine()
  let l:vimlabel = has("nvim") ?  " NVIM " : " VIM "
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'onedark'
set showtabline=2

" CtrlSF
nmap     <leader>/ <Plug>CtrlSFPrompt
nmap     <leader>* <Plug>CtrlSFCwordExec
vmap     <leader>/ <Plug>CtrlSFVwordExec
nnoremap <silent> <leader>sr :CtrlSFOpen<CR>
let g:ctrlsf_default_root = 'project' " search relative to project root
let g:ctrlsf_ackprg = '/usr/local/bin/rg'

if has('nvim')
  nnoremap <silent> <Leader>p :call mong8se#ActivateGitOrFiles()<CR>
  nnoremap <silent> <Leader>f :Telescope find_files<CR>
  nnoremap <silent> <Leader>h :Telescope commands<CR>
  " search
  nnoremap <silent> <Leader>sg :Telescope live_grep<CR>
  nnoremap <silent> <Leader>sh :Telescope search_history<CR>
  nnoremap <silent> <Leader>sf :Telescope current_buffer_fuzzy_find<CR>
  " code
  nnoremap <silent> <Leader>cr :Telescope lsp_references<CR>
  nnoremap <silent> <Leader>cj :Telescope lsp_document_symbols<CR>
  nnoremap <silent> <Leader>cJ :Telescope lsp_dynamic_workspace_symbols<CR>
  nnoremap <silent> <Leader>ca :Telescope lsp_code_actions<CR>
  nnoremap <silent> <Leader>cd :Telescope lsp_definitions<CR>
  nnoremap <silent> <Leader>ci :Telescope lsp_implementations<CR>
  nnoremap <silent> <Leader>ct :Telescope treesitter<CR>
  " insert
  nnoremap <silent> <Leader>ir :Telescope registers<CR>

else
  " FZF
  nnoremap <silent> <Leader>p :call mong8se#ActivateFZF()<CR>
  nnoremap <silent> <Leader>f :Files<CR>
  nnoremap <silent> <Leader>c :Commands<CR>
  nnoremap <Leader>a :Rg
  autocmd FileType fzf nmap <silent> <buffer> q :close<CR>
endif

" Ripgrep
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

" Dirvish
nmap <silent> \ :Dirvish<CR>
nmap <silent> - <Plug>(dirvish_up)
augroup dirvish_config
  autocmd!

  " Map `gr` to reload.
  autocmd FileType dirvish nnoremap <silent><buffer>
    \ gr :<C-U>Dirvish %<CR>

  " Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
  autocmd FileType dirvish nnoremap <silent><buffer>
    \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

  autocmd FileType dirvish :sort ,^.*[\/],
augroup END

" buffers
nmap <silent> ]b :bn<CR>
nmap <silent> [b :bp<CR>
if has('nvim')
  nnoremap <silent> <Leader><Space> :lua require'telescope.builtin'.buffers{sort_lastused=1}<CR>
else
  nnoremap <silent> <Leader><Space> :Buffers<CR>
endif

" tabs
nmap <silent> ]t :tabnext<CR>
nmap <silent> [t :tabprevious<CR>

" Golden Ratio
let g:golden_ratio_autocommand = 0
nmap <silent> <leader>gr <Plug>(golden_ratio_toggle)
" compare to <C-W>=
nmap <silent> <C-W>\ <Plug>(golden_ratio_resize)

" vim-sneak
let g:sneak#streak = 1

if has('nvim')

lua << EOF
-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

require'lspconfig'.tsserver.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.jsonls.setup{}
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
hi illuminatedWord cterm=underline gui=underline

" indentLine
let g:indentLine_char = "⡇"

"------------------------------------------------------------
" LOCALS

call mong8se#LoadRCFiles()
