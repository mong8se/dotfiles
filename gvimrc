" What a funny comment character
" .gvimrc
" v 0.3

" Turns on the tab bar always
set showtabline=2

" Number of horizontal lines on the screen
set lines=60

" GUI Option to remove the Toolbar (T)
set guioptions-=T

" Sets the font and size
set guifont=Inconsolata:h14

" Sets the percent transparency
set transparency=8

augroup automongoose
" Save files automatically when focus is lost
" Silent means don't bitch about unamed or readonline files
" Those silently fail
    autocmd BufLeave,FocusLost * silent! wall
    autocmd BufLeave,FocusLost * stopinsert
augroup END

" Auto load files that have local changes
set autoread

" Make command enter make a new line without splitting
inoremap <D-CR> <ESC>o

" Map Command T to CommandT plugin
if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  map <D-t> :CommandT<CR>
endif

" Command-/ to toggle comments
map <D-/> <plug>NERDCommenterToggle<CR>

" Command-][ to increase/decrease indentation
vnoremap <D-]> >>
vnoremap <D-[> <<
