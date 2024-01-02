if not type -q fzf_key_bindings
  if test -r /usr/share/fzf/shell/key-bindings.fish
    source  /usr/share/fzf/shell/key-bindings.fish
  else if test -r /usr/local/opt/fzf/shell/key-bindings.fish
    source /usr/local/opt/fzf/shell/key-bindings.fish
  end
end

fzf_key_bindings || echo "Warning: No FZF keybindings found"

bind \cz 'jobs -q; and fg'
