function fish_mode_prompt --description "Displays the current vi mode"
  # The fish_mode_prompt function is prepended to the prompt

  # Do nothing if not in vi mode
  if test $__fish_active_key_bindings = "fish_vi_key_bindings"
    switch $fish_bind_mode
      case default
        set_color  red
        echo '║'
      case insert
        set_color  green white
        echo '┃'
      case replace-one
        set_color  green
        echo '╳'
      case visual
        set_color  magenta
        echo '┊'
    end
    set_color normal
    # echo -n ' '
  end
end
