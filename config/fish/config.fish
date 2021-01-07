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
  if type -P (which figlet) >/dev/null
    and test -x (which figlet)
    set_color red
    figlet -c -w $COLUMNS -f smslant $hostname
    set_color normal
  end
end

if test (which nvim)
  set -x EDITOR (which nvim)
  set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
else
  set -x EDITOR (which vim)
end

function _run_fasd -e fish_preexec
  fasd --proc (fasd --sanitize "$argv") >"/dev/null" 2>&1
end

function z
  if count $argv >/dev/null
    cd (fasd -dl1 "$argv")
  else
    cd (fasd -dlR | fzf)
  end
end

function fv
  fzf -m --query="$argv[1]" --select-1 --exit-0 | xargs -o $EDITOR
end

function xsource -d "Source list of files if they exist."
  for file in $argv
    if test -f "$__fish_config_dir/$file"
      source "$__fish_config_dir/$file"
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
    if test (which abduco)
      abbr -a av abduco -A nvim nvim
    end
  end
  abbr -a em emacsclient
  abbr -a cd.. cd ..
  if set -q KITTY_WINDOW_ID
    alias icat="kitty +kitten icat"
    alias kg="kitty +kitten hyperlinked_grep"
  end

  # Feature Switches
  # if set -q ITERM_PROFILE
  # set -x HAS_UTF 0
  # set -x fish_emoji_width 2
  # else if set -q KITTY_WINDOW_ID
  set -e HAS_UTF
  # end

  # Set Base16 Shell Colors
  base16 gruvbox-dark-soft false

  set -x fish_color_error brred --italics
  set -x fish_color_autosuggestion brblack --italics

  if test (which fd)
    set -x FZF_DEFAULT_COMMAND 'fd --type f --no-ignore'
    set -x FZF_CTRL_T_COMMAND 'fd --type f . "$dir"'
  end

  function autoGrowl -d "Auto Growl" -e fish_postexec
    if test $CMD_DURATION -gt 5000
      printf "\a"
      growl finished: $argv
    end
  end
end

xsource _platform.fish

starship init fish | source

xsource _machine.fish local.fish
