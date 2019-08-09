function fish_prompt --description 'Write out the prompt'
  if test $status -gt 0
    set __prompt_choice "error"
  else
    switch $USER
    case root
      set __prompt_choice "root"
    case '*'
      set __prompt_choice "normal"
    end
  end

  if not set -q __fish_prompt_error
    set -g __fish_prompt_error (set_color normal $fish_color_error)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color $fish_color_normal)
  end

  if not set -q __fish_sigil_error
    if set -q HAS_UTF
      set -g __fish_sigil_error '☠️'
    else
      set -g __fish_sigil_error '*'
    end
  end

  if not set -q __fish_sigil_root
    if set -q HAS_UTF
      set -g __fish_sigil_root '🦄'
    else
      set -g __fish_sigil_root '$'
    end
  end

  if not set -q __fish_sigil_normal
    if set -q HAS_UTF
      set -g __fish_sigil_normal '🐙'
    else
      set -g __fish_sigil_normal '|'
    end
  end

  switch $__prompt_choice
  case "error"
    printf "%s%s" $__fish_prompt_error $__fish_sigil_error
  case "root"
    printf "%s%s" $__fish_prompt_normal $__fish_sigil_root
  case "*"
    printf "%s%s" $__fish_prompt_normal $__fish_sigil_normal
  end

  printf "%s%s" $__fish_prompt_normal " "
end
