function fish_right_prompt --description 'Write out the prompt'
  if not set -q __fish_git_prompt_show_informative_status
    set -g __fish_git_prompt_show_informative_status 0
  end

  if not set -q __fish_git_prompt_color_branch
    set -g __fish_git_prompt_color_branch --underline blue
  end

  if not set -q __fish_git_prompt_color_merging
    set -g __fish_git_prompt_color_merging red
  end

  if not set -q __fish_prompt_reverse
    set -g __fish_prompt_reverse (set_color --reverse)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1|tr '[:lower:]' '[:upper:]')
  end

  if not set -q __fish_color_host
    set -g __fish_color_host (set_color -r $fish_color_host)
  end

  if not set -q __fish_color_package_json
    set -g __fish_color_package_json (set_color --reverse yellow -b black)
  end

  if not set -q -g __fish_classic_git_functions_defined
    set -g __fish_classic_git_functions_defined

    function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
      if status --is-interactive
        set -e __fish_prompt_user
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
      if status --is-interactive
        set -e __fish_prompt_host
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
      if status --is-interactive
        set -e __fish_prompt_status
        commandline -f repaint ^/dev/null
      end
    end
  end

  if test -e package.json
    printf "%s %s|%s %s" "$__fish_color_package_json" (cat package.json | jq '.name, .version' -r) "$__fish_prompt_normal"
  end

  printf " %s%s" "$__fish_prompt_normal" (__fish_git_prompt "%s")
  # printf " %s%s%s" "$__fish_color_host" "$__fish_prompt_hostname" "$__fish_prompt_normal"
  printf " %s %s %s" "$__fish_prompt_reverse" (prompt_pwd) "$__fish_prompt_normal"
end
