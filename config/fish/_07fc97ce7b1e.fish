#domprox on

thefuck --alias | source

set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)
set -gx ANDROID_HOME {$HOME}/Library/Android/sdk
set PATH $PATH {$ANDROID_HOME}/platform-tools {$ANDROID_HOME}/tools

set -g fish_user_paths "/usr/local/opt/node@6/bin" $fish_user_paths