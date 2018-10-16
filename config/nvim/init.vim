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

set showmatch " show matching brackets

set hlsearch
set incsearch " show incremental search results

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

set title
set scrolloff=5
set nowrap
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

" Use a .vim_tmp directory in the project root, .config/nvim/tmp in your home dir, or
" lastly current folder.
set directory=./.vim_tmp,~/.config/nvim/tmp,.,/tmp
set backupdir=./.vim_tmp,~/.config/nvim/tmp,.,/tmp

if has('persistent_undo')
  set undodir=./.vim_tmp,~/.config/nvim/tmp,.,/tmp
  set undofile
endif

if ! has('nvim')
  " put viminfo in .config/nvim/tmp
  set viminfo='100,n$HOME/.config/nvim/tmp/viminfo

  " Add matching plugin to super power %
  runtime! macros/matchit.vim
else
  set shada=!,'100,<50,s10,h,n$HOME/.config/nvim/tmp/main.shada
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
  autocmd!

  " Leave insert or replace mode on focus lost
  autocmd BufLeave,FocusLost * if v:insertmode =~ '[ir]' | stopinsert | endif

  " When focus is lost, save the buffer if it is modified and has a filename
  autocmd BufLeave,FocusLost * if @% != '' && &modified | write | endif
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
"
vnoremap < <gv
vnoremap > >gv

" custom functions
nnoremap <silent> <Leader>n :call mong8se#ToggleNumberMode()<CR>

nnoremap <silent> <Leader>sb :call mong8se#ScrollBindAllWindows()<CR>

nnoremap [<cr>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<cr>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

if has('spell')
  set spelllang=en_us
  nnoremap <silent> <Leader>sc :setlocal spell!<CR>
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

if $BASE16 != ""
  let base16colorspace=256
  colorscheme $BASE16
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
  colorscheme gruvbox
endif

" need to install with `rake xterm-italic`
highlight Comment cterm=italic

"------------------------------------------------------------
" PLUGINS

let g:startify_custom_header =
      \ map(split(system('figlet -c -w $COLUMNS -f stampatello //'.mong8se#shortHostname()), '\n'), '"   ". v:val') + ['','']
let g:startify_list_order = [['// here'], 'dir', ['// anywhere'], 'files', ['// bookmarks'], 'bookmarks', ['// sessions'], 'sessions']
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')

" delimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr    = 2

" Fugitive
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>gc :Gcommit<cr>
nmap <silent> <leader>gl :Glog<cr>
nmap <silent> <leader>gd :Gdiff<cr>
nmap <silent> <leader>gb :Gbrowse<cr>
autocmd FileType gitcommit setlocal spell textwidth=72

" vim-signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime = 1
nmap <silent> <Leader>gt :SignifyToggle<CR>
nmap <silent> <leader>gh :SignifyToggleHighlight<CR>
nmap <silent> <leader>gf :SignifyFold<CR>
nmap <silent> <leader>gr :SignifyRefresh<CR>

" Airline
let g:airline_left_sep='│'
let g:airline_right_sep='│'
let g:airline_inactive_collapse=0
let g:airline#extensions#bufferline#enabled = 1
let g:bufferline_echo = 1
let g:airline#extensions#bufferline#overwrite_variables = 1

" CtrlSF
nmap     <leader>/ <Plug>CtrlSFPrompt
nmap     <leader>* <Plug>CtrlSFCwordExec
vmap     <leader>/ <Plug>CtrlSFVwordExec
nnoremap <silent> <leader>r :CtrlSFOpen<CR>
let g:ctrlsf_default_root = 'project' " search relative to project root
let g:ctrlsf_ackprg = '/usr/local/bin/rg'

" FZF
nnoremap <silent> <Leader>p :call mong8se#ActivateFZF()<CR>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>c :Commands<CR>
autocmd FileType fzf nmap <silent> <buffer> q :close<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
nnoremap <Leader>a :Rg 

" Dirvish
nmap <silent> \ :Dirvish<CR>
nmap <silent> - <Plug>(dirvish_up)
autocmd FileType dirvish call fugitive#detect(@%)               " enable git functions in dirvish view
autocmd FileType dirvish silent keeppatterns g@\v/\.[^\/]+/?$@d " remove dot files
autocmd FileType dirvish :sort r /[^\/]$/                       " sort directories to top

" buffers
let g:buffergator_suppress_keymaps = 1
nmap <silent> ]b :bn<CR>
nmap <silent> [b :bp<CR>
nmap <silent> <leader><Space> :BuffergatorOpen<CR>
let g:buffergator_sort_regime = "mru"
let g:buffergator_viewport_split_policy = "N"
let g:buffergator_show_full_directory_path = 0
let g:buffergator_display_regime = "parentdir"

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

" Incsearch
let g:incsearch#auto_nohlsearch = 1
let g:incsearch#magic = '\v' " very magic
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)zz
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
map *  <Plug>(incsearch-nohl-*)zz
map #  <Plug>(incsearch-nohl-#)zz
map g* <Plug>(incsearch-nohl-g*)zz
map g# <Plug>(incsearch-nohl-g#)zz

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Tab> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap gl <Plug>(EasyAlign)

" Neomake
" autocmd! BufWritePost * silent! Neomake
" autocmd! BufReadPost * silent! Neomake
" nmap <silent> ]e :lnext<CR>
" nmap <silent> [e :lprevious<CR>
nmap <silent> ]e <Plug>(ale_next)
nmap <silent> [e <Plug>(ale_previous)
nnoremap <silent> <Leader>ga :ALEFix<cr>
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['json'] = ['prettier']

" Only show quick-scope highlights after f/F/t/T is pressed
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" pretend these plugins are already loaded, so they don't load
let loaded_2html_plugin = 1
let loaded_matchparen   = 1
let loaded_netrw        = 1

" asynccomplete
if executable('flow-language-server')
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#flow#get_source_options({
"     \ 'name': 'flow',
"     \ 'whitelist': ['javascript'],
"     \ 'completor': function('asyncomplete#sources#flow#completor'),
"     \ 'config': {
"     \    " Resolves 'flow' in the closest node_modules/.bin directory (in case
"     \    " flow is installed via 'npm install flow-bin' locally). Falls back to
"     \    " 'flowbin_path' (see below) if can't find it.
"     \    'prefer_local': 1,
"     \    " Path to 'flow' executable.
"     \    'flowbin_path': expand('~/bin/flow'),
"     \    " Displays additional typeinfo exposed by flow, if any is provided. 
"     \    " Defaults to 0.
"     \    'show_typeinfo': 1
"     \  },
"     \ }))

    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'flow-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript'],
        \ })
endif

call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni',
\ 'whitelist': ['*'],
\ 'blacklist': ['c', 'cpp', 'html'],
\ 'completor': function('asyncomplete#sources#omni#completor')
\  }))

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

" vim-illuminate
hi illuminatedWord cterm=underline gui=underline

"------------------------------------------------------------
" LOCALS

call mong8se#LoadRCFiles()
