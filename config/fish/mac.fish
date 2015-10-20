function make_light -d "Switch iTerm profile to 'light'"
  set_iterm_profile 'light'
end

function make_dark -d "Switch iTerm profile to 'dark'"
  set_iterm_profile 'dark'
end

function flush_dns -d "Flush DNS Cache"
  /usr/bin/dscacheutil -flushcache
end

function pman -d "Open man page in Preview"
  man -t $argv | open -f -a /Applications/Preview.app
end

function rv
  fzf --query="$argv[1]" --select-1 --exit-0 | xargs -o mvim --servername (basename $PWD) --remote-silent
end

set -gx HOMEBREW_GITHUB_API_TOKEN ***REMOVED***

# items below require beta iterm2
function growl -d "Notify"
  echo -e "\e]9;$argv\007"
end

xsource iterm2_shell_integration.fish
