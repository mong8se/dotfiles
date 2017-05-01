function fish_mode_prompt --description "Displays the current vi mode"
  function changeCursor
    if set -q ITERM_PROFILE
        echo -e '\e]1337;CursorShape='$argv[1]'\a'
    end
  end

  # The fish_mode_prompt function is prepended to the prompt
  # Do nothing if not in vi mode
  if test $__fish_active_key_bindings = "fish_vi_key_bindings" -o $__fish_active_key_bindings = "fish_hybrid_key_bindings"
    switch $fish_bind_mode
      case default
        echo '📣 '
        changeCursor 0
      case insert
        echo '🖋️ '
        changeCursor 1
      case replace-one
        echo '🔨 '
        changeCursor 2
      case visual
        echo '🕯️ '
        changeCursor 0
    end
  end
end
