function fish_mode_prompt --description "Displays the current vi mode"
  function changeCursor
    switch $argv[1]
      case "block"
        if set -q ITERM_PROFILE
          echo -ne '\e]1337;CursorShape=0\a'
        else
          echo -ne '\e[1 q\a'
        end
      case "bar"
        if set -q ITERM_PROFILE
          echo -ne '\e]1337;CursorShape=1\a'
        else
          echo -ne '\e[5 q\a'
        end
      case "underscore"
        if set -q ITERM_PROFILE
          echo -ne '\e]1337;CursorShape=2\a'
        else
          echo -ne '\e[3 q\a'
        end
    end
  end

  if not set -q __fish_prompt_reverse
    set -g __fish_prompt_reverse (set_color --reverse)
  end

  if not set -q HAS_UTF
    echo -en $__fish_prompt_reverse
  end

# The fish_mode_prompt function is prepended to the prompt
# Do nothing if not in vi mode
if test $__fish_active_key_bindings = "fish_vi_key_bindings" -o $__fish_active_key_bindings = "fish_hybrid_key_bindings"
  switch $fish_bind_mode
    case default
      if set -q HAS_UTF
        echo -n '📣 '
      else
        echo -n ' N '
      end
      changeCursor "block"
    case insert
      if set -q HAS_UTF
        echo -n '🖋️ '
      else
        echo -n ' I '
      end
      changeCursor "bar"
    case replace-one
      if set -q HAS_UTF
        echo -n '🔨 '
      else
        echo -n ' C '
      end
      changeCursor "underscore"
    case visual
      if set -q HAS_UTF
        echo -n '🕯️ '
      else
        echo -n ' V '
      end
      changeCursor "block"
    end
  end
end
