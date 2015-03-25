#!/bin/env fish

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
