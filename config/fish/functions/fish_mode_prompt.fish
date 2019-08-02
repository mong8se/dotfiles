function fish_mode_prompt --description "Displays the current vi mode"
  function changeCursor
    switch $argv[1]
      case "block"
        if set -q ITERM_PROFILE
          printf '\e]1337;CursorShape=0\a'
        else
          printf '\e[1 q\a'
        end
      case "bar"
        if set -q ITERM_PROFILE
          printf '\e]1337;CursorShape=1\a'
        else
          printf '\e[5 q\a'
        end
      case "underscore"
        if set -q ITERM_PROFILE
          printf '\e]1337;CursorShape=2\a'
        else
          printf '\e[3 q\a'
        end
    end
  end

  if not set -q __fish_mode_prompt_insert
    set -g __fish_mode_prompt_insert (set_color --reverse)
  end

  if not set -q __fish_mode_prompt_normal
    set -g __fish_mode_prompt_normal (set_color blue --reverse)
  end

  if not set -q __fish_mode_prompt_visual
    set -g __fish_mode_prompt_visual (set_color red --reverse)
  end

  if not set -q __fish_mode_prompt_change
    set -g __fish_mode_prompt_change (set_color magenta --reverse)
  end

# The fish_mode_prompt function is prepended to the prompt
# Do nothing if not in vi mode
if test $__fish_active_key_bindings = "fish_vi_key_bindings" -o $__fish_active_key_bindings = "fish_hybrid_key_bindings"
  switch $fish_bind_mode
    case default
      if set -q HAS_UTF
        printf '📣'
      else
        printf "$__fish_mode_prompt_normal N "
      end
      changeCursor "block"
    case insert
      if set -q HAS_UTF
        printf '🖋️'
      else
        printf "$__fish_mode_prompt_insert I "
      end
      changeCursor "bar"
    case replace-one
      if set -q HAS_UTF
        printf '🔨'
      else
        printf "$__fish_mode_prompt_change C "
      end
      changeCursor "underscore"
    case visual
      if set -q HAS_UTF
        printf '🔎'
      else
        printf "$__fish_mode_prompt_visual V "
      end
      changeCursor "block"
    end
  end
end
