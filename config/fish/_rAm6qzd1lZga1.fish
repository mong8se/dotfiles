#!/usr/bin/env fish
#domprox on

thefuck --alias | source

set -gx JAVA_HOME (/usr/libexec/java_home)
set -gx ANDROID_HOME {$HOME}/Library/Android/sdk

set -gx TTC_REPOS {$HOME}/Projects
set -gx TTC_WEATHER "Ann Arbor, MI"
set -gx TTC_CELSIUS 0

set -g fish_user_paths "$HOME/.cargo/bin" "/usr/local/opt/node@12/bin" $fish_user_paths "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" "$HOME/Projects/Chrome/depot_tools" {$ANDROID_HOME}/platform-tools {$ANDROID_HOME}/tools {$HOME}/Library/Python/3.6/bin
set -gx NACL_SDK_ROOT "$HOME/Projects/Chrome/nacl_sdk/pepper_49"

# brew install entr
function pumlw -d "Watch plantuml and icat output"
  argparse 't/type=?' -- $argv

  set -l base (string replace .plantuml "" $argv[1])
  if [ "" = "$_flag_type" ]
    set _flag_type png
  end

  set -l icat

  if set -q KITTY_WINDOW_ID
    set icat "kitty +kitten icat"
  else if set -q ITERM_SESSION_ID
    set icat imgcat
    echo $icat
  else
    echo Did not detect kitty or iterm2
    return 1
  end

  echo $base.plantuml | entr -s "plantuml -t$_flag_type $base.plantuml ; $icat $base.$_flag_type"
end
