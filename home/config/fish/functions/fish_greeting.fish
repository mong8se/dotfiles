function fish_greeting
  if type -q figlet
    set_color red
    figlet -c -w $COLUMNS -f smslant $hostname
    set_color normal
  end
end
