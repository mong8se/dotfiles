function set_iterm_profile -d "Tell iTerm to switch profile"
  printf "\e]50;SetProfile=%s\a" "$argv[1]"
end
