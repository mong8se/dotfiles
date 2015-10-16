### MAC SPECFIC
# This sends growl a notification to iterm
function growl {
  terminal-notifier -message "$1"
}
# man pages in os x
function pman { man -t $@ | open -f -a /Applications/Preview.app }
function bman { gunzip < `man -w $@` | groff -Thtml -man | bcat }

alias flush_dns='/usr/bin/dscacheutil -flushcache'

function rv {
  local file
   file=$(fzf --query="$1" --select-1 --exit-0)
   [ -n "$file" ] && mvim --servername ${PWD##*/} --remote-silent "$file"
}

export HOMEBREW_GITHUB_API_TOKEN=***REMOVED***

fpath=(/usr/local/share/zsh-completions $fpath)

xsource $ZDOTDIR/iterm2_shell_integration.zsh
