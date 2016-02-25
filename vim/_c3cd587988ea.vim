set tags=./.tags,.tags
let g:ycm_collect_identifiers_from_tags_files=1

function CreateTags()
  let curNodePath = g:NERDTreeFileNode.GetSelected().path.str()
  exec ':!ctags --fields=+l -R -f ' . curNodePath . '/.tags ' . curNodePath
endfunction
nmap <silent> <F4> :call CreateTags()<CR>

let g:startify_bookmarks = [
                    \ '~/Projects/olo-vagrant/workspace/nolo-us-en',
                    \ '~/Projects/olo-vagrant',
                    \ ]

