function make_light -d "Switch iTerm profile to 'light'"
  set_iterm_profile 'light'
end

function make_dark -d "Switch iTerm profile to 'dark'"
  set_iterm_profile 'dark'
end

function growl -d "Notify"
  terminal-notifier -message "$argv[1]"
end

function flush_dns -d "Flush DNS Cache"
  /usr/bin/dscacheutil -flushcache
end

function pman -d "Open man page in Preview"
  man -t $argv | open -f -a /Applications/Preview.app
end

function rv
  set tmp $TMPDIR/fzf.result
  fzf --query="$argv[1]" --select-1 --exit-0 > $tmp
  if [ (cat $tmp | wc -l) -gt 0 ]
    mvim --servername (basename $PWD) --remote-silent (cat $tmp)
  end
end

set -Ux HOMEBREW_GITHUB_API_TOKEN ***REMOVED***