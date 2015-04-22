#!/bin/env fish

function fish_greeting
  if test -x (which figlet)
    set_color red
    hostname -s | figlet -cf thin
    set_color normal
  end
end

set -Ux EDITOR nvim

function -e fish_preexec _run_fasd
  fasd --proc (fasd --sanitize "$argv") > "/dev/null" 2>&1
end

function z
  cd (fasd -d -e 'printf %s' "$argv")
end

function fe
  set tmp $TMPDIR/fzf.result
  fzf --query="$argv[1]" --select-1 --exit-0 > $tmp
  if [ (cat $tmp | wc -l) -gt 0 ]
    nvim (cat $tmp)
  end
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

xsource local.fish
