" relative line numbers
function! custom#ToggleRelativeNumber()
  set number
  set relativenumber!
endfunction

" add blank line without entering insert mode
function! custom#ActivateCR(range)
  if empty(&buftype)
    execute a:range . "put _"
  else
    execute "normal! \<CR>"
  end
endfunction

" scroll bind all windows, works best with vertical splits
function! custom#ScrollBindAllWindows()
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
