# brew install entr
function pumlw -d "Watch plantuml and icat output"
  argparse 't/type=?' -- $argv

  if [ "" = "$_flag_type" ]
    set _flag_type png
  end

  set -l puml $argv[1]
  set -l img (path change-extension "$_flag_type" $argv[1])

  set -l icat

  if set -q KITTY_WINDOW_ID
    set icat "kitty +kitten icat --scale-up"
  else if set -q ITERM_SESSION_ID
    set icat imgcat
    echo $icat
  else
    echo Did not detect kitty or iterm2
    return 1
  end

  echo $puml | entr -c -s "plantuml -t$_flag_type $puml ; $icat $img"
end
