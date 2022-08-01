" in case we bypassed vimrc and loaded this file directly
set nocompatible
filetype off

call plug#begin("~/.config/nvim/plugged")

set rtp+=$DOTFILES_RESOURCES/fzf
Plug 'junegunn/fzf.vim'

Plug 'chriskempson/base16-vim'
Plug 'caglartoklu/borlandp.vim'
Plug 'gruvbox-community/gruvbox'

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'

Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'


Plug 'roman/golden-ratio' " C-W \

Plug 'unblevable/quick-scope' " f F t T
"Plug 'justinmk/vim-sneak'     " s or z with an operator

Plug 'danilamihailov/beacon.nvim'

Plug 'machakann/vim-sandwich' " sa sd sr
Plug 'tmsvg/pear-tree'

Plug 'justinmk/vim-dirvish'          " leader f

Plug 'glepnir/dashboard-nvim'
Plug 'mhinz/vim-startify'

Plug 'EinfachToll/DidYouMean'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-apathy' " ]f

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify' " ]c [c

Plug 'sheerun/vim-polyglot'
Plug 'wellle/context.vim'

Plug 'tpope/vim-abolish'
Plug 'tomtom/tcomment_vim' "gc

Plug 'dyng/ctrlsf.vim'                 " leader /
Plug 'RRethy/vim-illuminate'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ryanolsonx/vim-lsp-javascript'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'vimwiki/vimwiki'

Plug 'severin-lemaignan/vim-minimap', { 'on': 'Minimap' }
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'mtth/scratch.vim', { 'on': 'Scratch' } " gs

call mong8se#LoadRCFiles('plugs')

call plug#end()

filetype plugin indent on    " required
