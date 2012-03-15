" What a funny comment character
" .gvimrc
" v 0.5

" Focus follows mouse
" set mousefocus

" Turns on the tab bar always
set showtabline=2

" Number of horizontal lines on the screen
set lines=60

" GUI Option to remove the Toolbar (T)
set guioptions-=T

" Sets the font and size
set guifont=Inconsolata-dz\ for\ Powerline:h12

" Sets the percent transparency
set transparency=5

augroup automongoose
" Save files automatically when focus is lost
" Silent means don't bitch about unamed or readonline files
" Those silently fail
    autocmd BufLeave,FocusLost * if mode()[0] =~ 'i\|R' | call feedkeys("\<Esc>") | endif
    autocmd BufLeave,FocusLost * silent! wall
augroup END

" Auto load files that have local changes
set autoread

" Make command enter make a new line without splitting
inoremap <D-CR> <ESC>o

" Map Command T to CtrlP in case of muscle memory
if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  map <D-t> :CtrlP<CR>
endif

" Command-][ to increase/decrease indentation
nnoremap <D-]> >>
nnoremap <D-[> <<
vnoremap <D-]> >>
vnoremap <D-[> <<
