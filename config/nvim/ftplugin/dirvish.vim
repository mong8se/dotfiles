sort ,^.*[\/],

" Map `gr` to reload.
nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

" Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nmap <silent> - <Plug>(dirvish_up)
