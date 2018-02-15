fzf_key_bindings

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
