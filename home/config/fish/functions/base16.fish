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
    case reset
      set -e BASE16_THEME
      return 0
    end

    set -l scheme_script "$__base16_path/base16-$scheme_name.sh"

    if test -e "$scheme_script"
      if test "$__base16_scheme_script" != "$scheme_script"
        set -g __base16_scheme_script $scheme_script

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

function auto_gruv -d "Auto Gruv" -e fish_prompt
  if status --is-interactive
    set -gx IS_DARK_MODE (isDarkMode; and echo 1; or echo 0)

    if not set -q BASE16_THEME
      if test "$IS_DARK_MODE" = 0
        base16 light true
      else
        base16 dark true
      end
    end

    # always activate the theme in case the last command messed with our colors.
    if test -e "$__base16_scheme_script"
      sh $__base16_scheme_script
    end
  end
end
