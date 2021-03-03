set -g fish_user_paths "/usr/local/opt/node@10/bin" $fish_user_paths

function unifi_server
  echo Starting unifi server, access at https://localhost:8443/login\?url=/manage
  echo ctrl-c to stop it ...
  java -jar /Applications/UniFi.app/Contents/Resources/lib/ace.jar ui
end
