function fish_prompt --description 'Write out the prompt'

  if test $status -gt 0
    echo -n -s $__fish_error_sigil
  else
    if not set -q __fish_prompt_normal
      set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_root_sigil
      if test $IS_MAC
        set -g __fish_root_sigil '🦄 '
      else
        set -g __fish_root_sigil 'u'
      end
    end

    if not set -q __fish_normal_sigil
      if test $IS_MAC
        set -g __fish_normal_sigil '🐙 '
      else
        set -g __fish_normal_sigil 'o'
      end
    end

    if not set -q __fish_error_sigil
      if test $IS_MAC
        set -g __fish_error_sigil '☠️ '
      else
        set -g __fish_error_sigil 's'
      end
    end

    switch $USER
    case root
      echo -n -s $__fish_root_sigil
    case '*'
      echo -n -s $__fish_normal_sigil
    end
  end

  echo -n -s -e " $__fish_prompt_normal"
end
