#!/bin/env fish

fish_vi_mode

function fish_greeting
  if type -P (which figlet) > /dev/null; and test -x (which figlet)
    set_color red
    hostname -s | figlet -c -w $COLUMNS -f thin
    set_color normal
  end
end

set -Ux EDITOR nvim

function -e fish_preexec _run_fasd
  fasd --proc (fasd --sanitize "$argv") > "/dev/null" 2>&1
end

function z
  set -l result

  if count $argv > /dev/null
    set result (fasd -d -e 'printf %s' "$argv")
  else
    set tmp $TMPDIR/fzf.result
    fasd -Rdl | fzf --no-sort +m > $tmp
    if [ (cat $tmp | wc -l) -gt 0 ]
      set result (cat $tmp)
   end
  end
  cd $result
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

if test `uname`="Darwin"
  xsource mac.fish
end

# Base16 Shell
eval sh $HOME/.dotfiles/Resources/base16-shell/base16-bespin.dark.sh

xsource _(hostname -s).fish local.fish

set -Ux PASSWORD_STORE_DIR ~/Dropbox/.password-store
