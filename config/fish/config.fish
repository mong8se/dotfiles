#!/bin/env fish

fish_hybrid_key_bindings

function fish_greeting
  if type -P (which figlet) > /dev/null; and test -x (which figlet)
    set_color red
    hostname -s | figlet -c -w $COLUMNS -f thin
    set_color normal
  end
end

if test (which nvim)
  set -x EDITOR nvim
  set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
else
  set -x EDITOR vi
end

function _run_fasd -e fish_preexec
  fasd --proc (fasd --sanitize "$argv") > "/dev/null" 2>&1
end

function z
  if count $argv > /dev/null
    cd (fasd -dl1 "$argv")
  else
    cd (fasd -dlR | fzf)
  end
end

function fv
  fzf -m --query="$argv[1]" --select-1 --exit-0 | xargs -o nvim
end

function xsource -d "Source list of files if they exist."
  set -l fish_home ~/.config/fish
  for file in $argv
    if test -f $fish_home/$file
      source $fish_home/$file
    end
  end
end

if status --is-interactive
  abbr -a gls git ls-files
  abbr -a vi nvim
  abbr -a em emacsclient
  abbr -a cd.. cd ..

  # Feature Switches
  # if set -q ITERM_PROFILE
    # set -x HAS_UTF 0
    # set -x fish_emoji_width 2
  # else if set -q KITTY_WINDOW_ID
    set -e HAS_UTF
  # end

  # Set Base16 Shell Colors
  if set -q ITERM_PROFILE
    switch "$ITERM_PROFILE"
    case light
      base16 gruvbox-light-soft
    case dark
      base16 gruvbox-dark-soft
    case '*'
      base16 eighties
    end
  else
    base16 gruvbox-dark-soft
  end

  # Remove the environment variable as it's the default, not user set
  set -e BASE16
end

if test (uname) = "Darwin"
  set -x IS_MAC 0
  xsource mac.fish
end

xsource _(hostname -s | tr -d '\n' | /usr/bin/shasum -p -a 256 | cut -c1-12).fish local.fish

set -x PASSWORD_STORE_DIR ~/Dropbox/.password-store
set -x FZF_DEFAULT_OPTS '--height 40% --reverse'
