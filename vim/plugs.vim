" Source a local configuration file if available.
" Takes arguments and constructs filename for example:
" g:LoadRcFiles('first', 'second', third') would load:
" mac.first.second.third.vim
" local.first.second.third.vim
" hostname.first.second.third.vim

function! g:LoadRCFiles(...)
  for l:rc_type in ['mac', '_' . substitute(hostname(), '\..*', '', ''), 'local']
    if l:rc_type == 'mac' && !has('macunix')
      continue
    endif
    let l:rc_file = join([l:rc_type] + a:000 + ['vim'], '.')
    execute 'runtime' l:rc_file
  endfor
endfunction

set nocompatible " in case we bypassed vimrc
filetype off

set rtp+=~/.dotfiles/Resources/fzf

call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'
" Plug 'zhaocai/GoldenView.Vim'
Plug 'roman/golden-ratio'
Plug 'unblevable/quick-scope'

Plug 'jeetsukumaran/vim-buffergator'   " leader b
Plug 'jeetsukumaran/vim-filebeagle'    " leader f
Plug 'EinfachToll/DidYouMean'

Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'mhinz/vim-signify' " ]c [c

Plug 'vim-ruby/vim-ruby',      { 'for': 'ruby' }
Plug 'tpope/vim-rails',        { 'for': 'ruby' }
Plug 'tpope/vim-endwise',      { 'for': 'ruby' }
Plug 'tpope/vim-rake',         { 'for': 'ruby' }
Plug 'slim-template/vim-slim', { 'for': 'ruby' }

Plug 'dag/vim-fish', { 'for': 'fish' }

Plug 'othree/html5.vim'

Plug 'tpope/vim-abolish', { 'on': 'Subvert' }
Plug 'tomtom/tcomment_vim' "gc
Plug 'tpope/vim-surround'   " cs ds ys
Plug 'junegunn/rainbow_parentheses.vim', { 'on': 'RainbowParentheses' }
Plug 'junegunn/vim-easy-align' "v tab
Plug 'tommcdo/vim-exchange'            " cx

Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object' " ai
Plug 'nathanaelkane/vim-indent-guides' " <leader> ig
Plug 'wellle/targets.vim'

Plug 'haya14busa/incsearch.vim'        " /
Plug 'dyng/ctrlsf.vim'                 " leader /

Plug 'Lokaltog/vim-easymotion'         " s

Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'scrooloose/syntastic'

Plug 'ryanoasis/vim-devicons'

call g:LoadRCFiles('plugs')

call plug#end()

filetype plugin indent on    " required
