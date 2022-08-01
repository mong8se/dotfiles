# brew install entr
function pumlw -d "Watch plantuml and icat output"
  argparse 't/type=?' -- $argv

  set -l base (string replace .plantuml "" $argv[1])
  if [ "" = "$_flag_type" ]
    set _flag_type png
  end

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

  echo $base.plantuml | entr -c -s "plantuml -t$_flag_type $base.plantuml ; $icat $base.$_flag_type"
end
