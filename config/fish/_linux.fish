  if set -q KITTY_WINDOW_ID
    alias pbcopy="kitty +kitten clipboard"
    alias pbpaste="kitty +kitten clipboard --get-clipboard"
  end
