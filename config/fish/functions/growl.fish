function growl -d "Send Notification"
# requires iterm2 or kitty
  printf "\e]9;%s\a" "$argv"
end
