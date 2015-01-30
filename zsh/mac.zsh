### MAC SPECFIC
# This sends growl a notification to iterm
function growl {
  terminal-notifier -message "$1"
}
# man pages in os x
function pman { man -t $@ | open -f -a /Applications/Preview.app }
function bman { gunzip < `man -w $@` | groff -Thtml -man | bcat }

alias flush_dns='/usr/bin/dscacheutil -flushcache'

if [[ $TERM_PROGRAM == iTerm.app ]];then
  # Turn off xon/xoff so that ctrl-s is passed through
  stty -ixon

  export EDITOR='mvim -f --nomru -c "au VimLeave * !open -a iTerm"'
else
  export EDITOR='mvim -f --nomru -c "au VimLeave * !open -a Terminal"'
fi

function rv {
  local file
   file=$(fzf --query="$1" --select-1 --exit-0)
   [ -n "$file" ] && mvim --servername ${PWD##*/} --remote-silent "$file"
}

export HOMEBREW_GITHUB_API_TOKEN=***REMOVED***

fpath=(/usr/local/share/zsh-completions $fpath)