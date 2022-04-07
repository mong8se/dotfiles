#!/usr/bin/env fish

if not set -q hostname
  set -g hostname (hostname -s)
end

if not set -q DOTFILES_RESOURCES
  set -x DOTFILES_RESOURCES ~/.dotfiles/Resources
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

function fish_greeting
  if type -q figlet
    set_color red
    figlet -c -w $COLUMNS -f smslant $hostname
    set_color normal
  end
end

if type -q nvim
  set -x EDITOR (which nvim)
  set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
else
  set -x EDITOR (which vim)
end

function xsource -d "Source list of files if they exist."
  for file in $argv
    if test ! (string match '/*' "$file")
      set file "$__fish_config_dir/$file"
    end
    if test -f "$file"
      source "$file"
    end
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

  abbr -a gls git ls-files
  if string match --quiet '*nvim' "$EDITOR"
    abbr -a vi nvim
    if type -q abduco
      abbr -a av abduco -A nvim nvim
    end
  end

  abbr -a em emacsclient
  abbr -a cd.. cd ..

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

  if type -q zoxide
    zoxide init fish --no-aliases | source
    function z
      if count $argv > "/dev/null"
        set -xg __zoxide_last_argv $argv
        __zoxide_z $argv
      else
        __zoxide_zi
      end
    end
    function zz
      __zoxide_z $__zoxide_last_argv
    end
  else if type -q fasd
    if type -q disown
      function __fasd_run --on-variable PWD
        command fasd --proc (command fasd --sanitize "$argv" | tr -s ' ' \n) > "/dev/null" 2>&1 &; disown
      end
    else
      function __fasd_run --on-variable PWD
        command fasd --proc (command fasd --sanitize "$argv" | tr -s ' ' \n) > "/dev/null" 2>&1 &
      end
    end

    function __fasd_query
      if count $argv > "/dev/null"
        command fasd -dl1 "$argv"
      else
        command fasd -dlR | fzf
      end
    end
    function z
      set -l result (__fasd_query $argv)
      test -z "$result"; and return
      test -d "$result"; and cd "$result"
    end
  end

  function fv
    fzf -m --query="$argv[1]" --select-1 --exit-0 | xargs -o $EDITOR
  end

  if type -q starship
    starship init fish | source
  end
end

set -x ASDF_DIR "$DOTFILES_RESOURCES/asdf"
set -x ASDF_DATA_DIR "$ASDF_DIR"
source $ASDF_DIR/asdf.fish

xsource _platform.fish

xsource _machine.fish local.fish
