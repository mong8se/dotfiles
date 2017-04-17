function fish_prompt --description 'Write out the prompt'
  if test $status = 0
    switch $USER
    case root
      echo -n '🦄 '
    case '*'
      echo -n '🐙 '
    end
  else
    echo -n '☠️ '
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  echo -n -s -e "$__fish_prompt_normal"
end
