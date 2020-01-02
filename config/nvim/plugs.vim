" in case we bypassed vimrc and loaded this file directly
set nocompatible
filetype off

call plug#begin("~/.config/nvim/plugged")

set rtp+=~/.dotfiles/Resources/fzf
Plug 'junegunn/fzf.vim'

Plug 'chriskempson/base16-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'caglartoklu/borlandp.vim'

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-apathy'

Plug 'rbong/vim-crystalline'

Plug 'roman/golden-ratio'
Plug 'ciaranm/securemodelines'

Plug 'unblevable/quick-scope' " f F t T
Plug 'justinmk/vim-sneak'     " s or z with an operator

Plug 'justinmk/vim-dirvish'          " leader f

Plug 'EinfachToll/DidYouMean'
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-rooter'

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify' " ]c [c

Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-abolish'
Plug 'tomtom/tcomment_vim' "gc
Plug 'tpope/vim-surround'      " cs ds ys
Plug 'tommcdo/vim-exchange'    " cx

Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object' " ai
Plug 'nathanaelkane/vim-indent-guides' " <leader> ig
Plug 'wellle/targets.vim'

Plug 'dyng/ctrlsf.vim'                 " leader /
Plug 'RRethy/vim-illuminate'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ryanolsonx/vim-lsp-javascript'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'severin-lemaignan/vim-minimap', { 'on': 'Minimap' }
Plug 'mtth/scratch.vim', { 'on': 'Scratch' } " gs

call mong8se#LoadRCFiles('plugs')

call plug#end()

filetype plugin indent on    " required
