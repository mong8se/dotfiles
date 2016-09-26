" first part of hostname
function! mong8se#shortHostname()
  return substitute(hostname(), '\..*', '', '')
endfunction

" Source a local configuration file if available.
" Takes arguments and constructs filename for example:
" g:LoadRcFiles('first', 'second', third') would load:
" mac.first.second.third.vim
" local.first.second.third.vim
" _hostname.first.second.third.vim
function! mong8se#LoadRCFiles(...)
  for l:rc_type in ['mac', '_' . sha256( mong8se#shortHostname() )[0:11], 'local']
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
    windo set nonumber
    windo set norelativenumber
  elseif &number
    windo set relativenumber
  else
    windo set number
  end
endfunction

" scroll bind all windows, works best with vertical splits
function! mong8se#ScrollBindAllWindows()
  if &scrollbind
    windo setlocal noscrollbind
  else
    windo setlocal scrollbind
    syncbind
  endif
endfunction

" fzf
function! mong8se#ActivateFZF()
  if exists('b:git_dir')
    GitFiles
  else
    Files
  endif
endfunction
