" Source a local configuration file if available.
" Takes arguments and constructs filename for example:
" g:LoadRcFiles('first', 'second', third') would load:
" mac.first.second.third.vim
" local.first.second.third.vim
" _hostname.first.second.third.vim
function! mong8se#LoadRCFiles(...)
  for l:rc_type in ['mac', '_' . sha256( substitute(hostname(), '\..*', '', '') )[0:11], 'local']
    if l:rc_type == 'mac' && !has('macunix')
      continue
    endif
    let l:rc_file = join([l:rc_type] + a:000 + ['vim'], '.')
    execute 'runtime' l:rc_file
  endfor
endfunction

" toggle line numbers
function! mong8se#ToggleNumberMode()
  if &relativenumber
    set nonumber
    set norelativenumber
  elseif &number
    set relativenumber
  else
    set number
  end
endfunction

" add blank line without entering insert mode
function! mong8se#ActivateCR(range)
  if empty(&buftype)
    execute a:range . "put _"
  else
    execute "normal! \<CR>"
  end
endfunction

" scroll bind all windows, works best with vertical splits
function! mong8se#ScrollBindAllWindows()
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

" fzf
function! mong8se#ActivateFZF()
  if exists('b:git_dir')
    GitFiles
  else
    Files
  endif
endfunction
