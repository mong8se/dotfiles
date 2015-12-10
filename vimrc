" Base config with vundle
runtime plugs.vim

syntax on

set hidden
set encoding=utf-8

set timeoutlen=1200 " A little bit more time for macros
set ttimeoutlen=33  " Make Esc work faster

set wildmenu
set wildmode=longest:full,full

set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/* "

set showcmd
set cmdheight=2
set laststatus=2

set mouse=a        " mouse for all
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
set number
set timeoutlen=500

set pastetoggle=<F11>
au InsertLeave * set nopaste " Automatically leave paste mode when leaving insert mode

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

set title
set scrolloff=3
set virtualedit=block,insert " allow cursor to go where there is nothing

set list listchars=tab:╾╌,trail:⎵,extends:…,precedes:…

" so complex operations dont display until finished
set lazyredraw
set ttyfast

set splitright " new vertical splits are to the right
set splitbelow " new horizontal splits are below

" Use a .vim_tmp directory in the project root, .vim/tmp in your home dir, or
" lastly current folder.
set directory=./.vim_tmp,~/.vim/tmp,.,/tmp
set backupdir=./.vim_tmp,~/.vim/tmp,.,/tmp

if has('persistent_undo')
    set undodir=./.vim_tmp,~/.vim/tmp,.,/tmp
    set undofile
endif

if ! has('nvim')
  " put viminfo in .vim/tmp
  set viminfo='100,n$HOME/.vim/tmp/viminfo

  " Add matching plugin to super power %
  runtime! macros/matchit.vim
end

set foldlevelstart=99
set foldmethod=manual

if has('clipboard')
    if has('x11') && version >= 703
        " Default yank and paste go to system clipboard
        set clipboard=unnamedplus
    else
        set clipboard=unnamed
    endif
endif

" cursorline only for active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

augroup FocusIssues
    " Leave insert or replace mode on focus lost
    autocmd BufLeave,FocusLost * if v:insertmode =~ '[ir]' | call feedkeys("\<C-\>\<C-n>") | endif

    " Automatically try to save current buffer if focus lost
    autocmd BufLeave,FocusLost * if &modifiable | silent! w | endif
augroup END

"------------------------------------------------------------
" MAPPINGS

" Set <Leader> key
noremap <Space> <Nop>
let mapleader = "\<Space>"

" Move lines
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" I can type :help on my own, thanks.
noremap <F1> <Nop>
noremap! <F1> <Esc>

" Map Y to act like D and C, i.e. to yank until EOL,
" rather than act as yy, which is the default
nnoremap Y y$

" Map U to redo
nnoremap U <C-r>

" Instead of look up in man, let's split, opposite of J for join
nnoremap K i<CR><Esc>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <silent> <C-L> :nohl<CR><C-L>

" Arrow keys move up and down visible lines, not physical lines
nnoremap <Down> gj
nnoremap <Up> gk

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

" relative line numbers
function! g:ToggleRelativeNumber()
  set number
  set relativenumber!
endfunction
nnoremap <silent> <Leader>n :call g:ToggleRelativeNumber()<CR>

" add blank line without entering insert mode
function! g:ActivateCR(range)
    if empty(&buftype)
        execute a:range . "put _"
    else
        execute "normal! \<CR>"
    end
endfunction
nnoremap <silent> <Leader><CR>   :call g:ActivateCR('.')<CR>
nnoremap <silent> <Leader><S-CR> :call g:ActivateCR('-1')<CR>

function! g:ScrollBindAllWindows()
  let l:starting_window = winnr()
  let l:starting_line = line('.')
  if &scrollbind
    windo setlocal noscrollbind
  else
    windo normal gg
    windo setlocal scrollbind
  endif
  exec l:starting_window . 'wincmd w'
  exec l:starting_line
endfunction
nnoremap <silent> <Leader>sb :call g:ScrollBindAllWindows()<CR>

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
" PLUGINS

" If we're not in iterm, specifically request dark profile
if has('nvim') || $TERM_PROGRAM !~ "iTerm"
  set background=dark
endif
let base16colorspace=256
" colorscheme base16-default
colorscheme gruvbox

let g:startify_custom_header =
      \ map(split(system('hostname -s | figlet -c -w $COLUMNS -f thin'), '\n'), '"   ". v:val') + ['','']
let g:startify_list_order = [['// here'], 'dir', ['// anywhere'], 'files', ['// bookmarks'], 'bookmarks', ['// sessions'], 'sessions']

" delimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr    = 2

" Fugitive
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>gc :Gcommit<cr>
nmap <silent> <leader>gl :Glog<cr>
nmap <silent> <leader>gd :Gdiff<cr>
nmap <silent> <leader>gb :Gbrowse<cr>
autocmd Filetype gitcommit setlocal spell textwidth=72

" gitv
let g:Gitv_WrapLines = 1
let g:Gitv_OpenHorizontal = 'auto'

" vim-signify
let g:signify_vcs_list = [ 'git', 'svn', 'hg' ]
nmap <silent> <Leader>gt :SignifyToggle<CR>
nmap <silent> <leader>gh :SignifyToggleHighlight<CR>
nmap <silent> <leader>gf :SignifyFold<CR>
nmap <silent> <leader>gr :SignifyRefresh<CR>

" Airline
let g:airline_left_sep='│'
let g:airline_right_sep='│'

" fzf
nnoremap <silent> <Leader>t :FZF<CR>

" CtrlSF
nmap     <leader>/ <Plug>CtrlSFPrompt
nmap     <leader>* <Plug>CtrlSFCwordExec
vmap     <leader>/ <Plug>CtrlSFVwordExec
nnoremap <silent> <leader>r :CtrlSFOpen<CR>
let g:ctrlsf_regex_pattern = 1 " search with regex by default
let g:ctrlsf_default_root = 'project' " search relative to project root

" buffers
let g:buffergator_suppress_keymaps = 1
nmap <silent> ]b :bn<CR>
nmap <silent> [b :bp<CR>
nmap <silent> <leader><Space> :BuffergatorOpen<CR>
let g:buffergator_sort_regime = "mru"
let g:buffergator_viewport_split_policy = "N"
let g:buffergator_show_full_directory_path = 0

" Golden Ratio
nmap <silent> <leader>gr <Plug>(golden_ratio_toggle)

" vim sneak
let g:sneak#streak = 1

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Tab> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap gl <Plug>(EasyAlign)

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 0
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_error_symbol             = "✗"
let g:syntastic_warning_symbol           = "⚠"
nmap <silent> ]e :lnext<CR>
nmap <silent> [e :lprevious<CR>

" Only show quick-scope highlights after f/F/t/T is pressed
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

"------------------------------------------------------------
" LOCALS

call g:LoadRCFiles()
