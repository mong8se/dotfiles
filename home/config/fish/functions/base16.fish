if not set -q __base16_path
  set -g __base16_path $DOTFILES_RESOURCES/base16-shell/scripts
end

function __base16_schemes
  command ls $__base16_path/*.sh | string match -g -r 'base16-([^/\.]+)\.sh$'
end

complete -c base16 -a "(__base16_schemes)" -d "Color scheme name"

function base16 -d "Activate base16 terminal color scheme" -a new_theme -a skip_env
  if status --is-interactive

    if test -z "$new_theme"
      set new_theme (__base16_schemes | string split " " | fzf)
    end

    if test "$new_theme" = random
      set new_theme (random choice (__base16_schemes))
    end

    set -l theme_script "$__base16_path/base16-$new_theme.sh"

    if test -e "$theme_script"
      sh $theme_script
      source {$DOTFILES_RESOURCES}/base16-fzf/fish/base16-{$new_theme}.fish

      if test -n "$skip_env"
        set -e BASE16_THEME
      else
        set -xg BASE16_THEME {$new_theme}
      end

      if type -q vivid
        set -gx LS_COLORS (vivid generate base16-{$new_theme})
      end
    else
      echo "base16 error: $new_theme not found"
      return 1
    end
  else
    echo "base16 doing nothing: non interactive shell"
  end
end

function autoGruv -d "Auto Gruv" -e fish_prompt
  if status --is-interactive && not set -q BASE16_THEME
    if isDarkMode
      set -gx IS_DARK_MODE 1
      base16 gruvbox-dark-soft false
    else
      set -gx IS_DARK_MODE 0
      base16 equilibrium-light false
    end
  end
end
