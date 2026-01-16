if not set -q __base16_path
  set -g __base16_path $DOTFILES_RESOURCES/base16-shell/scripts
end

if not set -q __base16_default_light
  set -g __base16_default_light precious-light-warm
end

if not set -q __base16_default_dark
  set -g __base16_default_dark gruvbox-dark-soft
end

function __base16_schemes
  command ls $__base16_path/*.sh | string match -g -r 'base16-([^/\.]+)\.sh$'
end

complete -c base16 -a "(__base16_schemes)" -d "Color scheme name"

function base16 -d "Activate base16 terminal color scheme" -a scheme_name -a make_default
  if status --is-interactive

    switch "$scheme_name"
    case ''
      set scheme_name (__base16_schemes | string split " " | fzf)
    case random
      set scheme_name (random choice (__base16_schemes))
    case light
      set scheme_name $__base16_default_light
    case dark
      set scheme_name $__base16_default_dark
    end

    set -l scheme_script "$__base16_path/base16-$scheme_name.sh"

    if test -e "$scheme_script"
      # always activate the theme in case the last command messed with our colors.
      sh $scheme_script

      if test "$__base16_applied_scheme" != "$scheme_name"
        set -gx __base16_applied_scheme $scheme_name
        if test -n "$make_default"
          set -e BASE16_THEME
        else
          set -gx BASE16_THEME {$scheme_name}
        end

        source {$DOTFILES_RESOURCES}/base16-fzf/fish/base16-{$scheme_name}.fish

        if type -q vivid
          set -gx LS_COLORS (vivid generate base16-{$scheme_name})
        end
      end

      return 0
    else
      echo "base16 error: $scheme_name not found"
      return 1
    end
  else
    echo "base16 doing nothing: non interactive shell"
  end
end

function autoGruv -d "Auto Gruv" -e fish_prompt
  if status --is-interactive
    set -gx IS_DARK_MODE (isDarkMode; and echo 1; or echo 0)

    if set -q BASE16_THEME
      base16 $BASE16_THEME
    else if test "$IS_DARK_MODE" = 0
      base16 $__base16_default_light true
    else
      base16 $__base16_default_dark true
    end
  end
end
