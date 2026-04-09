#!/usr/bin/env fish

if status --is-interactive
  and type -q thefuck
  thefuck --alias | source
end

set -x HOMEBREW_CASK_OPTS "--appdir=~/Applications"

set -x JAVA_HOME (/usr/libexec/java_home)
set -x ANDROID_HOME {$HOME}/Library/Android/sdk

set -x TTC_REPOS {$HOME}/Projects
set -x TTC_WEATHER "Ann Arbor, MI"
set -x TTC_CELSIUS 0

fish_add_path --append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" "$HOME/Projects/Chrome/depot_tools" {$ANDROID_HOME}/platform-tools {$ANDROID_HOME}/tools {$HOME}/Library/Python/3.6/bin

set -x NACL_SDK_ROOT "$HOME/Projects/Chrome/nacl_sdk/pepper_49"

set -a Z_FALLBACKS ~/Projects/unvagrant/workspace

set -x NODE_EXTRA_CA_CERTS ~/Projects/unvagrant/certs/dpzca.pem

launchctl setenv NODE_EXTRA_CA_CERTS $NODE_EXTRA_CA_CERTS
