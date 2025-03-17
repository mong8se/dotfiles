#!/usr/bin/env fish
#domprox on

thefuck --alias | source

set -gx JAVA_HOME (/usr/libexec/java_home)
set -gx ANDROID_HOME {$HOME}/Library/Android/sdk

set -gx TTC_REPOS {$HOME}/Projects
set -gx TTC_WEATHER "Ann Arbor, MI"
set -gx TTC_CELSIUS 0

fish_add_path --append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" "$HOME/Projects/Chrome/depot_tools" {$ANDROID_HOME}/platform-tools {$ANDROID_HOME}/tools {$HOME}/Library/Python/3.6/bin

set -gx NACL_SDK_ROOT "$HOME/Projects/Chrome/nacl_sdk/pepper_49"

set -a Z_FALLBACKS ~/Projects/unvagrant/workspace

set -gx NODE_EXTRA_CA_CERTS ~/Projects/unvagrant/certs/dpzca.pem

launchctl setenv NODE_EXTRA_CA_CERTS $NODE_EXTRA_CA_CERTS
