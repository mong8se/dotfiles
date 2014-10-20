" Source a local configuration file if available.
" Takes arguments and constructs filename for example:
" g:LoadRcFiles('first', 'second', third') would load:
" ~/.vimrc.first.second.third.local
" ~/.vimrc.first.second.third.mac
" ~/.vimrc.first.second.third.hostname
"
function! g:LoadRCFiles(...)
  for l:rc_extension in ['local', 'mac', substitute(hostname(), '\..*', '', '')]
  let l:rc_file = join([$MYVIMRC] + a:000 + [l:rc_extension], '.')
   if filereadable(expand(l:rc_file))
     execute 'source' l:rc_file
   endif
  endfor
endfunction

" Base config with vundle
source $MYVIMRC.vundle.conf

syntax on

set hidden
set encoding=utf-8

set wildmenu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/* "

set showcmd
set cmdheight=2
set laststatus=2

set hlsearch
set showmatch " show matching brackets
set incsearch " show incremental search results

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
set cursorline " highlight current line
set virtualedit=block,insert " allow cursor to go where there is nothing
" highlight trailing whitepsace with a ·
set list listchars=tab:•·,trail:…,extends:›,precedes:‹

" so complex operations dont display until finished
set lazyredraw
set ttyfast

set splitright " new vertical splits are to the right

" Use a .vim directory in the project root, .vim/tmp in your home dir, or
" lastly current folder.
set directory=./.vim_tmp,~/.vim/tmp,.,/tmp
set backupdir=./.vim_tmp,~/.vim/tmp,.,/tmp

if has('persistent_undo')
    set undodir=./.vim_tmp,~/.vim/tmp,.,/tmp
    set undofile
endif

set foldlevelstart=99
set foldmethod=syntax

runtime macros/matchit.vim

if has('clipboard')
    if has('x11') && version >= 703
        " Default yank and paste go to system clipboard
        set clipboard=unnamedplus
    else
        set clipboard=unnamed
    endif
endif

"------------------------------------------------------------
" MAPPINGS

" Set <Leader> key
noremap <Space> <Nop>
let mapleader = "\<Space>"

" I can type :help on my own, thanks.
noremap <F1> <Nop>
noremap! <F1> <Esc>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
nnoremap Y y$

" Map U to redo
nnoremap U <C-r>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <silent> <C-L> :nohl<CR><C-L>

" Arrow keys move up and down visible lines, not physical lines
nnoremap <Down> gj
nnoremap <Up> gk

" always search with magic mode
nnoremap / /\v

" Original mapping
nnoremap Q gq

" Window movement
function! g:WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr()) "we havent moved
    if (match(a:key,'[jk]')) "were we going up/down
      wincmd v
    else 
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

nnoremap <silent> <Leader>h :call g:WinMove('h')<cr>
nnoremap <silent> <Leader>k :call g:WinMove('k')<cr>
nnoremap <silent> <Leader>l :call g:WinMove('l')<cr>
nnoremap <silent> <Leader>j :call g:WinMove('j')<cr>

nnoremap <silent> <Leader>wc :wincmd q<cr>
nnoremap <silent> <Leader>wr <C-W>r

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

" Always keep current search result centered
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" add blank line without entering insert mode
function! g:ActivateCR(range)
    if empty(&buftype)
        execute a:range . "put _"
    else
        execute "normal! \<CR>"
    end
endfunction
nnoremap <silent> <CR> :call g:ActivateCR('.')<CR>
nnoremap <silent> <S-CR> :call g:ActivateCR('-1')<CR>

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

"------------------------------------------------------------
" PLUGINS

" NERDTree
let NERDTreeShowBookmarks = 1
let NERDChristmasTree = 1
let NERDTreeWinPos = "left"
let NERDTreeChDirMode = 2
let NERDTreeMouseMode = 2
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

nnoremap <silent> <Leader><Space> :NERDTreeToggle <cr>
nnoremap <silent> <Leader>f :NERDTreeFind <cr>

let g:ackprg = 'ag --nogroup --nocolor --column'

" Solarized
set background=dark
colorscheme base16-eighties
set t_Co=16

" Command T
let g:CommandTMaxHeight = 15
let g:CommandTFileScanner = 'git'
let g:CommandTTraverseSCM = 'dir'
let g:CommandTMatchWindowReverse = 1
" if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
"   let g:CommandTCancelMap = ['<ESC>', '<C-c>']
" endif

" delimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

" Fugitive
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gb :Gbrowse<cr>

" gitv
let g:Gitv_WrapLines = 1

" vim-gitgutter
nnoremap <silent> <Leader>c :GitGutterToggle<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"------------------------------------------------------------
" LOCALS

call g:LoadRCFiles()
