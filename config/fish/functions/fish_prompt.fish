function fish_prompt --description 'Write out the prompt'
  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end
  switch $USER
  case root
    if not set -q __fish_prompt_color
      if set -q fish_color_cwd_root
        set -g __fish_prompt_color (set_color $fish_color_cwd_root)'Ⓡ '
      else
        set -g __fish_prompt_color (set_color $fish_color_cwd)'Ⓡ '
      end
    end
  case '*'
    if not set -q __fish_prompt_color
      set -g __fish_prompt_color (set_color $fish_color_history_current)'◯ '
    end
  end
  echo -n -s -e "$__fish_prompt_color" "$__fish_prompt_normal"
end
