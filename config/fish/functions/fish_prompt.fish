function fish_prompt --description 'Write out the prompt'
  if test $status -gt 0
    if not set -q __fish_prompt_error
      set -g __fish_prompt_error (set_color normal $fish_color_error)
    end

    if not set -q __fish_error_sigil
      if set -q HAS_UTF
        set -g __fish_error_sigil '☠️'
      else
        set -g __fish_error_sigil '*'
      end
    end

    echo -nse $__fish_prompt_error $__fish_error_sigil
  else
    if not set -q __fish_prompt_normal
      set -g __fish_prompt_normal (set_color $fish_color_normal)
    end

    echo -ne $__fish_prompt_normal

    if not set -q __fish_root_sigil
      if set -q HAS_UTF
        set -g __fish_root_sigil '🦄'
      else
        set -g __fish_root_sigil '$'
      end
    end

    if not set -q __fish_normal_sigil
      if set -q HAS_UTF
        set -g __fish_normal_sigil '🐙'
      else
        set -g __fish_normal_sigil '|'
      end
    end

    switch $USER
    case root
      echo -n -s $__fish_root_sigil
    case '*'
      echo -n -s $__fish_normal_sigil
    end
  end

  echo -nse $__fish_prompt_normal " "
end
