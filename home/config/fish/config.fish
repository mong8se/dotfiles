#!/usr/bin/env fish

if not set -q hostname
  set -g hostname (hostname -s)
end

set -x DOTFILES_RESOURCES ~/.dotfiles/Resources
set -x EDITOR (command -v nvim || command -v vim || command -v vi)

function fish_greeting
  if type -q figlet
    set_color red
    figlet -c -w $COLUMNS -f smslant $hostname
    set_color normal
  end
end

if not set -q HOMEBREW_PREFIX
  set -l brew_path
  for test_path in /home/linuxbrew/.linuxbrew/bin/brew ~/.linuxbrew/bin/brew /usr/local/bin/brew
    if test -x $test_path
      set brew_path "$test_path"
      break
    end
  end

  if test -n "$brew_path"
    eval ($brew_path shellenv)
  end
end

if status --is-interactive
  if set -q VIM_TERMINAL
    fish_default_key_bindings
  else if type -q fish_hybrid_key_bindings
    fish_hybrid_key_bindings
  else
    fish_vi_key_bindings
  end

  set -x FZF_DEFAULT_OPTS "
  --height 40% --reverse --extended --cycle
  "

  abbr -a lsg git ls-files
  abbr -a cat cat -v

  # because half the time I type cd.. instead of cd ..
  function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 3) ../)
  end
  abbr --add dotdot --regex '^cd\.\.+$' --function multicd

  # Imitate Bash !!
  function last_history_item; echo $history[1]; end
  abbr -a !! --position anywhere --function last_history_item
 
  # Imitate Bash !$
  # function last_history_arg; string split --fields 2 --max 1 --right " " $history[1]; end
  # abbr -a !\$ --position anywhere --function last_history_arg

  # Imitate Bash !:1
  function nth_argument; string split --fields (math (string sub -s -1 $argv[1]) + 1) " " $history[1]; end
  abbr --add bangcolon --regex '!:\d' --position anywhere --function nth_argument

  # Imitate Bash ^abc^def
  # if ever the abbr regex returns the () matches
  # function replace_last_history; string replace $argv[2] $argv[3] $history[1]; end
  function replace_last_history
    set -l parts (string split "^" $argv)
    string replace $parts[2] $parts[3] $history[1]
  end
  abbr --add lastsub --regex '^\^(\w+)\^(\w+)$' --function replace_last_history

  if test "nvim" = (path basename "$EDITOR")
    abbr -a vi nvim
    if type -q abduco
      abbr -a av abduco -A nvim nvim
    end
  end

  if type -q lsd
    abbr tree lsd --tree
    abbr ls lsd
  end

  if set -q KITTY_WINDOW_ID
    alias icat="kitty +kitten icat"
    alias kg="kitty +kitten hyperlinked_grep"
    alias ssh="kitty +kitten ssh"
  end

  # Set Base16 Shell Colors
  base16 gruvbox-dark-soft false

  set -x fish_color_error brred --italics
  set -x fish_color_autosuggestion brblack --italics

  if type -q fd
    set -x FZF_DEFAULT_COMMAND 'fd --type f --no-ignore'
    set -x FZF_CTRL_T_COMMAND 'fd --type f . "$dir"'
  else if type -q rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore-vcs --hidden'
    set -x FZF_CTRL_T_COMMAND 'rg --files . "$dir"'
  end

  function autoGrowl -d "Auto Growl" -e fish_postexec
    if test $CMD_DURATION -gt 5000
      printf "\a"
      growl finished: $argv
    end
  end

  function fv
    fzf -m --query="$argv[1]" --select-1 --exit-0 | xargs -o $EDITOR
  end

  if type -q starship
    starship init fish | source
  end

  if ! type -q fisher
    read -n 1 -p 'set_color green; echo -n "Install fisher? (y/N) " ; set_color normal' answer
    if test "$answer" = "y" -o "$answer" = "Y"
      echo Installing...
      curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end
  end

  set -x Z_FALLBACKS ~/Projects ~/Work
end

fish_add_path ~/.cargo/bin

set -x BC_ENV_ARGS ~/.config/bcrc
set -x ASDF_DIR "$DOTFILES_RESOURCES/asdf"
set -x ASDF_DATA_DIR "$ASDF_DIR"
source $ASDF_DIR/asdf.fish
