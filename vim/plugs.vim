" Source a local configuration file if available.
" Takes arguments and constructs filename for example:
" g:LoadRcFiles('first', 'second', third') would load:
" mac.first.second.third.vim
" local.first.second.third.vim
" hostname.first.second.third.vim

function! g:LoadRCFiles(...)
  for l:rc_type in ['mac', 'local', substitute(hostname(), '\..*', '', '')]
    let l:rc_file = join([l:rc_type] + a:000 + ['vim'], '.')
    execute 'runtime' l:rc_file
  endfor
endfunction

set nocompatible " in case we bypassed vimrc
filetype off

call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'

if $TERM_PROGRAM =~ "iTerm"
  Plug 'sjl/vitality.vim'
endif

Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'airblade/vim-gitgutter'

Plug 'vim-ruby/vim-ruby',      { 'for': 'ruby' }
Plug 'tpope/vim-rails',        { 'for': 'ruby' }
Plug 'tpope/vim-endwise',      { 'for': 'ruby' }
Plug 'tpope/vim-rake',         { 'for': 'ruby' }
Plug 'slim-template/vim-slim', { 'for': 'ruby' }

Plug 'tpope/vim-abolish', { 'on': 'Subvert' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tommcdo/vim-lion'
Plug 'AndrewRadev/splitjoin.vim'

Plug 'haya14busa/incsearch.vim'

Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'
" Plug 'Shougo/neomru.vim'
" Plug 'Shougo/vimfiler.vim'
"
Plug 'jeetsukumaran/vim-filebeagle'

Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'scrooloose/syntastic'

" Plug 'ervandew/supertab'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

call g:LoadRCFiles('plugs')

call plug#end()

filetype plugin indent on    " required
