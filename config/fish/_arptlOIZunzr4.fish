function unifi_server
  echo Starting unifi server, access at https://localhost:8443/login\?url=/manage
  echo ctrl-c to stop it ...
  java -jar /Applications/UniFi.app/Contents/Resources/lib/ace.jar ui
end
