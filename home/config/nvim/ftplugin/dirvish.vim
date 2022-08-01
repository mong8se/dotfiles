" Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
nmap <silent> <buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nmap <silent> <buffer> - <Plug>(dirvish_up)

sort ,^.*[\/],
