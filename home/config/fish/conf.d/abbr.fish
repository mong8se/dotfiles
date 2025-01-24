status is-interactive || exit

abbr -a lsg git ls-files
abbr -a cat cat -v
abbr -a nrs npm run start
abbr -a --set-cursor gits git s%

# because half the time I type cd.. instead of cd ..
function multicd
  echo cd (string repeat -n (math (string length -- $argv[1]) - 3) ../)
end
abbr --add dotdot --regex '^cd\.\.+$' --function multicd

# Imitate Bash !!
function last_history_item
  echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

# Imitate Bash !$
function last_history_arg
  commandline -f history-token-search-backward
end
abbr -a !\$ --position anywhere --function last_history_arg

# Imitate Bash !:1
function nth_argument
  string split --fields (math (string sub -s -1 $argv[1]) + 1) " " $history[1]
end
abbr --add bangcolon --regex '!:\d' --position anywhere --function nth_argument

# Imitate Bash ^abc^def
# if ever the abbr regex returns the () matches
# function replace_last_history; string replace $argv[2] $argv[3] $history[1]; end
function replace_last_history
  set -l parts (string split "^" $argv)
  string replace $parts[2] $parts[3] $history[1]
end
abbr --add lastsub --regex '^\^(\w+)\^(\w+)$' --function replace_last_history

# Interactive change
function change_last_history
  string replace (string sub -s 2 $argv) % $history[1]
end
abbr --add lastchange --regex '^\^(\w+)$' --set-cursor --function change_last_history

# Imitate Zsh =somecommand
function which_commander
  string sub -s 2 $argv | xargs command -v
end
abbr --add equalcommand --regex "=\w+" --position anywhere --function which_commander

if type -q lsd
  abbr tree lsd --tree
  abbr ls lsd
end

if type -q nvim
  abbr vi nvim
end

if set -q KITTY_WINDOW_ID
  alias icat="kitty +kitten icat"
  alias kg="kitty +kitten hyperlinked_grep"
  alias ssh="kitty +kitten ssh"
end
