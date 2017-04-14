function fish_mode_prompt --description "Displays the current vi mode"
  # The fish_mode_prompt function is prepended to the prompt
  # Do nothing if not in vi mode
  if test $__fish_active_key_bindings = "fish_vi_key_bindings" -o $__fish_active_key_bindings = "fish_hybrid_key_bindings"
    switch $fish_bind_mode
      case default
        echo '📣 '
      case insert
        echo '🖋️ '
      case replace-one
        echo '🔨 '
      case visual
        echo '🕯️ '
    end
  end
end
