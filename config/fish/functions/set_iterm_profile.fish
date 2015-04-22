function set_iterm_profile -d "Tell iTerm to switch profile"
  echo -ne "\e]50;SetProfile="$argv[1]"\a"
end
