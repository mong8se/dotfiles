if not type -q fzf_key_bindings
  xsource /usr/share/fzf/shell/key-bindings.fish /usr/local/opt/fzf/shell/key-bindings.fish
end

fzf_key_bindings || echo "Warning: No FZF keybindings found"

function bind_bang
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function bind_dollar
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if bind -M insert > /dev/null 2>&1
  bind -M insert ! bind_bang
  bind -M insert '$' bind_dollar
else
  bind ! bind_bang
  bind '$' bind_dollar
end
