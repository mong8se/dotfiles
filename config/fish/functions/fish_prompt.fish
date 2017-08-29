function fish_prompt --description 'Write out the prompt'
  set -l sigil

  if test $status = 0
    switch $USER
    case root
      if test $IS_MAC
        set sigil '🦄 '
        else
          set sigil 'u'
        end
    case '*'
      if test $IS_MAC
        set sigil '🐙 '
      else
        set sigil 'o'
      end
    end
  else
    if test $IS_MAC
      set sigil '☠️ '
    else
      set sigil 's'
    end
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  echo -n -s -e "$sigil " "$__fish_prompt_normal"
end
