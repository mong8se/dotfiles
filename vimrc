" Base config with vundle
runtime plugs.vim

syntax on

set hidden
set encoding=utf-8

set wildmenu
" set wildmode=list:longest,list:full
" set wildmode=longest,list:longest
set wildmode=longest:full,full

set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/* "

set showcmd
set cmdheight =2
set laststatus=2

set mouse=a        " mouse for all
if ! has('nvim')
  set ttymouse=sgr   " mouse works past 223 columns
end

set showmatch " show matching brackets

set hlsearch
set incsearch " show incremental search results

" haya14busa/incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)

map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
map *  <Plug>(incsearch-nohl-*)zz
map #  <Plug>(incsearch-nohl-#)zz
map g* <Plug>(incsearch-nohl-g*)zz
map g# <Plug>(incsearch-nohl-g#)zz
let g:incsearch#magic = '\v'

" Modelines have historically been a source of security vulnerabilities.
set nomodeline

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

set list listchars=tab:┠╌,trail:⎵,extends:▶,precedes:◀

" so complex operations dont display until finished
set lazyredraw
set ttyfast

set splitright " new vertical splits are to the right
set splitbelow " new horizontal splits are below

" Use a .vim directory in the project root, .vim/tmp in your home dir, or
" lastly current folder.
set directory=./.vim_tmp,~/.vim/tmp,.,/tmp
set backupdir=./.vim_tmp,~/.vim/tmp,.,/tmp

if has('persistent_undo')
    set undodir=./.vim_tmp,~/.vim/tmp,.,/tmp
    set undofile
endif

set foldlevelstart=99
set foldmethod=manual

runtime! macros/matchit.vim

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

"------------------------------------------------------------
" MAPPINGS

" Set <Leader> key
noremap <Space> <Nop>
let mapleader = "\<Space>"

" I can type :help on my own, thanks.
noremap <F1> <Nop>
noremap! <F1> <Esc>

" Map Y to act like D and C, i.e. to yank until EOL,
" rather than act as yy, which is the default
nnoremap Y y$

" Map U to redo
nnoremap U <C-r>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <silent> <C-L> :nohl<CR><C-L>

" Arrow keys move up and down visible lines, not physical lines
nnoremap <Down> gj
nnoremap <Up> gk

" Original mapping
nnoremap Q gq

" reselect the text that was just pasted so I can perform commands (like indentation) on it:
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

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
endif

"------------------------------------------------------------
" PLUGINS

" If we're not in iterm, specifically request dark profile
if has('nvim') || $TERM_PROGRAM !~ "iTerm"
  set background=dark
endif
colorscheme base16-eighties

" delimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr    = 2

" Fugitive
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>gc :Gcommit<cr>
nmap <silent> <leader>gl :Glog<cr>
nmap <silent> <leader>gd :Gdiff<cr>
nmap <silent> <leader>gb :Gbrowse<cr>

" gitv
let g:Gitv_WrapLines = 1
let g:Gitv_OpenHorizontal = 'auto'

" vim-signify
let g:signify_vcs_list = [ 'git', 'svn', 'hg' ]
nmap <silent> <Leader>gt :SignifyToggle<CR>
nmap <silent> <leader>gh :SignifyToggleHighlight<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" fzf
nnoremap <silent> <leader>t :FZF<CR>

" CtrlSF
nmap     <leader>/ <Plug>CtrlSFPrompt
vmap     <leader>/ <Plug>CtrlSFVwordExec
nnoremap <silent> <leader>r :CtrlSFOpen<CR>

" CtrlSpace
nnoremap <silent> <leader><Space> :CtrlSpace<cr>
" nnoremap <silent> <leader>t :CtrlSpace O<cr>
let g:ctrlspace_save_workspace_on_exit       = 1
let g:ctrlsspace_save_workspace_on_switch    = 1
let g:ctrlspace_load_last_workspace_on_start = 1
let g:ctrlspace_cache_dir                    = "~/.vim"

" Golden Ratio
nmap <silent> <leader>gr <Plug>(golden_ratio_toggle)

" easy motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase  = 1 " Turn on case insensitive feature
nmap s <Plug>(easymotion-s2)
nmap <leader>s <Plug>(easymotion-sn)

"------------------------------------------------------------
" LOCALS

call g:LoadRCFiles()
