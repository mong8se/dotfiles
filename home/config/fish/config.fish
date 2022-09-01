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

function xsource -d "Source list of files if they exist."
  for file in $argv
    if test "/" != (string sub -e 1 "$file")
      set file "$__fish_config_dir/$file"
    end
    if test -f "$file"
      source "$file"
    end
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
  abbr -a cd.. cd ..

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

  function actually -e fish_postexec
    set -f last_status $status
    if test $last_status -gt 0
      set -f last_cmd (string split " " $argv[1])
      if test "cd" = "$last_cmd[1]"
         # using string replace to do tilde expansion manually, not sure if there is a way
         # to get it to work automatically when inside a variable from a split string
         set -f last_dir (path dirname $last_cmd[2] | string replace -r '^~' "$HOME")
         set -f last_base (path basename $last_cmd[2])
         set -l list (command find "$last_dir" -maxdepth 1 -mindepth 1 -name "$last_base"'*' | path sort)

         if test "$list" = ""
           return
         end

         set -l i 1
         set_color blue
         echo um ... actually, you probably meant:
         set_color normal
         for dir in $list
           echo $i $dir
           set i (math $i + 1)
         end
         set -l answer (read -n 1 -p 'set_color green; echo -n "> " ; set_color normal')
         if string match -r '^\d+$' "$answer"; and test -n "$list[$answer]" -a -d "$list[$answer]"
           cd "$list[$answer]"
         else
           echo nevermind
           return 1
         end
      end
    end
  end

  if type -q starship
    starship init fish | source
  end

  set -x Z_FALLBACKS ~/Projects ~/Work
end

fish_add_path ~/.cargo/bin

set -x ASDF_DIR "$DOTFILES_RESOURCES/asdf"
set -x ASDF_DATA_DIR "$ASDF_DIR"
source $ASDF_DIR/asdf.fish

xsource _platform.fish

xsource _machine.fish local.fish
