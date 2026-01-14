if not set -q __base16_path
  set -g __base16_path $DOTFILES_RESOURCES/base16-shell/scripts
end

function __base16_schemes
  command ls $__base16_path/*.sh | string match -g -r 'base16-([^/\.]+)\.sh$'
end

complete -c base16 -a "(__base16_schemes)" -d "Color scheme name"

set BASE16_DEFAULT_LIGHT precious-light-warm
set BASE16_DEFAULT_DARK gruvbox-dark-soft

function base16 -d "Activate base16 terminal color scheme" -a new_theme -a make_default
  if status --is-interactive

    switch "$new_theme"
    case ''
      set new_theme (__base16_schemes | string split " " | fzf)
    case random
      set new_theme (random choice (__base16_schemes))
    case light
      set new_theme $BASE16_DEFAULT_LIGHT
    case dark
      set new_theme $BASE16_DEFAULT_DARK
    end

    set -l theme_script "$__base16_path/base16-$new_theme.sh"

    if test -e "$theme_script"
      sh $theme_script
      source {$DOTFILES_RESOURCES}/base16-fzf/fish/base16-{$new_theme}.fish

      if type -q vivid
        set -gx LS_COLORS (vivid generate base16-{$new_theme})
      end

      if test -n "$make_default"
        set -xg BASE16_DEFAULT_SET {$new_theme}
        set -e BASE16_THEME
      else
        set -e BASE16_DEFAULT_SET
        set -xg BASE16_THEME {$new_theme}
      end

      return 0
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
      if test "$BASE16_DEFAULT_SET" != "$BASE16_DEFAULT_DARK"
        set -gx IS_DARK_MODE 1
        base16 $BASE16_DEFAULT_DARK true
      end
    else
      if test "$BASE16_DEFAULT_SET" != "$BASE16_DEFAULT_LIGHT"
        set -gx IS_DARK_MODE 0
        base16 $BASE16_DEFAULT_LIGHT true
      end
    end
  end
end
