" in case we bypassed vimrc and loaded this file directly
set nocompatible
filetype off

call plug#begin("~/.config/nvim/plugged")

if has('nvim')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
else
  set rtp+=$DOTFILES_RESOURCES/fzf
  Plug 'junegunn/fzf.vim'
endif

Plug 'chriskempson/base16-vim'
Plug 'caglartoklu/borlandp.vim'
if has('nvim')
  Plug 'eddyekofo94/gruvbox-flat.nvim'
else
  Plug 'gruvbox-community/gruvbox'
endif

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'

Plug 'rbong/vim-crystalline'
" Plug 'itchyny/lightline.vim'

Plug 'roman/golden-ratio' " C-W \

Plug 'unblevable/quick-scope' " f F t T
Plug 'justinmk/vim-sneak'     " s or z with an operator
Plug 'danilamihailov/beacon.nvim'
" Plug 'psliwka/vim-smoothie'

Plug 'machakann/vim-sandwich' " sa sd sr
Plug 'tmsvg/pear-tree'

Plug 'justinmk/vim-dirvish'          " leader f

if has('nvim')
  Plug 'glepnir/dashboard-nvim'
else
  Plug 'mhinz/vim-startify'
endif
Plug 'EinfachToll/DidYouMean'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-apathy' " ]f

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify' " ]c [c

Plug 'sheerun/vim-polyglot'
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
  Plug 'romgrk/nvim-treesitter-context'
else
  Plug 'wellle/context.vim'
endif

Plug 'tpope/vim-abolish'
Plug 'tomtom/tcomment_vim' "gc
Plug 'tommcdo/vim-exchange'    " cx

Plug 'dyng/ctrlsf.vim'                 " leader /
Plug 'RRethy/vim-illuminate'

Plug 'nathanaelkane/vim-indent-guides' " <leader> ig
Plug 'Yggdroot/indentLine'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
else
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'ryanolsonx/vim-lsp-javascript'

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif

Plug 'vimwiki/vimwiki'

Plug 'severin-lemaignan/vim-minimap', { 'on': 'Minimap' }
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'mtth/scratch.vim', { 'on': 'Scratch' } " gs

call mong8se#LoadRCFiles('plugs')

call plug#end()

filetype plugin indent on    " required
