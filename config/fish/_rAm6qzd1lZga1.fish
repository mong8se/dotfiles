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

