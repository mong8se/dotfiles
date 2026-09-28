function growl -d "Send Notification"
  if set -q KITTY_WINDOW_ID
    kitten notify $argv
  else
    printf "\e]9;%s\a" "$argv"
  end
end
