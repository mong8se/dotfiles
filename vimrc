" Start with base setup with vundle
source ~/.vimrc.vundle

syntax on

set hidden
set encoding=utf-8

set wildmenu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/* "

set showcmd

set hlsearch
set showmatch " show matching brackets
set incsearch " show incremental search results

" Modelines have historically been a source of security vulnerabilities.  As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
set nomodeline

set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

set timeoutlen=500

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Automatically leave paste mode when leaving insert mode
au InsertLeave * set nopaste

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" Set the teriminal title
set title

" Maintain more context around the cursor
set scrolloff=3

set cursorline " highlight current line
" allow cursor to go where there is nothing
set virtualedit=block,insert
" highlight trailing whitepsace with a ·
set list listchars=tab:•·,trail:·,extends:›,precedes:‹
" so complex operations dont display until finished
set lazyredraw
set ttyfast

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

if version >= 703 && has('clipboard')
    if has('x11')
        " Default yank and paste go to system clipboard
        set clipboard=unnamedplus
    else
        set clipboard=unnamed
    endif
endif

"------------------------------------------------------------
" MAPPINGS

" Set leader key
noremap <Space> <Nop>
let mapleader = "\<Space>"

" I can type :help on my own, thanks.
noremap <F1> <Esc>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <silent> <C-L> :nohl<CR><C-L>

" Arrow keys move up and down visible lines, not physical lines
nnoremap <Down> gj
nnoremap <Up> gk

" Window movement
function! WinMove(key) 
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

map <leader>h :call WinMove('h')<cr>
map <leader>k :call WinMove('k')<cr>
map <leader>l :call WinMove('l')<cr>
map <leader>j :call WinMove('j')<cr>

map <leader>wc :wincmd q<cr>
map <leader>wr <C-W>r

" reselect the text that was just pasted so I can perform commands (like indentation) on it:
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" relative line numbers
function! g:ToggleNuMode()
    if(&rnu == 1)
        set nu
    else
        set rnu
    endif
endfunc

nnoremap <silent> <leader>n :call g:ToggleNuMode()<cr>

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

map <silent> <leader><Space> :NERDTreeToggle <cr>
map <silent> <leader>f :NERDTreeFind <cr>

" Solarized
set background=dark
colorscheme solarized
set t_Co=16
let g:solarized_termcolors=   16
let g:solarized_termtrans =   0
let g:solarized_degrade   =   0
let g:solarized_bold      =   1
let g:solarized_underline =   1
let g:solarized_italic    =   1
let g:solarized_contrast  =   "normal"
let g:solarized_visibility=   "normal"
let g:solarized_hitrail   =   0
let g:solarized_menu      =   1

" CtrlP
let g:ctrlp_extensions = ['tag']
let g:ctrlp_map = '<leader>t'
map <leader>b :CtrlPBuffer<cr>
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_dotfiles = 0
let g:ctrlp_cache_dir = $HOME.'/.vim/tmp/ctrlp'

" delimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

" gitv
let g:Gitv_WrapLines = 1

" -----
" neocomplcache vvv
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
" inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" neocomplcache ^^^
" -----

" Turn off auto rails prompt
" let g:rails_statusline = 0

" Powerline
let g:Powerline_symbols = 'unicode'

"------------------------------------------------------------
" LOCALS

" Source a local configuration file if available.
" For loops only work in 7.x
for rc_extension in ["local", "mac"]
    let rc_file = "~/.vimrc." . rc_extension
    if filereadable(expand(rc_file))
        execute 'source' rc_file
    endif
endfor
