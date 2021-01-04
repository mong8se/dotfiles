if not set -q __base16_path
  set -g __base16_path $RESOURCES/base16-shell/scripts
end

function __base16_schemes
  ls $__base16_path/*.sh | string replace -f -r '^.*/base16-(.+)\.sh$' '$1'
end

complete -c base16 -a "(__base16_schemes)" -d "Color scheme name"

function base16 -d "Activate base16 terminal color scheme" -a new_theme -a skip_env
  if status --is-interactive

    if test -z "$new_theme"
      set new_theme (__base16_schemes | string split " " | fzf)
    end

    if test -n "$skip_env"
      set -e BASE16_THEME
    else
      set -xg BASE16_THEME base16-{$new_theme}
    end

    sh {$__base16_path}/base16-{$new_theme}.sh
    source {$RESOURCES}/base16-fzf/fish/base16-{$new_theme}.fish
  else
    echo "base16 doing nothing: Non interactive shell"
  end
end
