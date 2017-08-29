" in case we bypassed vimrc and loaded this file directly
set nocompatible
filetype off

call plug#begin("~/.config/nvim/plugged")

set rtp+=~/.dotfiles/Resources/fzf
Plug 'junegunn/fzf.vim'

Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'alessandroyorba/despacio'
Plug 'AlessandroYorba/Alduin'

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'

Plug 'bling/vim-airline'
Plug 'bling/vim-bufferline'

Plug 'roman/golden-ratio'
Plug 'ciaranm/securemodelines'
Plug 'unblevable/quick-scope' " f F t T
Plug 'justinmk/vim-sneak'     " s or z with an operator

Plug 'jeetsukumaran/vim-buffergator' " leader b
Plug 'justinmk/vim-dirvish'          " leader f

Plug 'EinfachToll/DidYouMean'
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-rooter'

Plug 'tpope/vim-fugitive' | Plug 'junegunn/gv.vim', { 'on': 'GV' }

Plug 'mhinz/vim-signify' " ]c [c

Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-abolish', { 'on': 'Subvert' }
Plug 'tpope/vim-commentary'     " gc
Plug 'tpope/vim-surround'      " cs ds ys
Plug 'junegunn/vim-easy-align' " v tab
Plug 'tommcdo/vim-exchange'    " cx

Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object' " ai
Plug 'nathanaelkane/vim-indent-guides' " <leader> ig
Plug 'wellle/targets.vim'

Plug 'dyng/ctrlsf.vim'                 " leader /
Plug 'haya14busa/incsearch.vim'

" Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py' }
" Plug 'neomake/neomake'
Plug 'roxma/nvim-completion-manager'
Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'neomake/neomake'
Plug 'w0rp/ale'

Plug 'severin-lemaignan/vim-minimap', { 'on': 'Minimap' }
Plug 'mtth/scratch.vim', { 'on': 'Scratch' } " gs

call mong8se#LoadRCFiles('plugs')

call plug#end()

filetype plugin indent on    " required
