if not set -q __base16_path
    set -g __base16_path $DOTFILES_RESOURCES/base16-shell/scripts
end

if not set -q __base16_default_light
    set -gx __base16_default_light penumbra-light-contrast-plus-plus
end

if not set -q __base16_default_dark
    set -gx __base16_default_dark gruvbox-dark-soft
end

function __base16_schemes
    command ls $__base16_path/*.sh | string match -g -r 'base16-([^/\.]+)\.sh$'
end

complete -c base16 --no-files
complete -c base16 -a random -d "Random color scheme"
complete -c base16 -a light -d "Default light scheme"
complete -c base16 -a dark -d "Default dark scheme"
complete -c base16 -a reset -d "Reset to default scheme"
complete -c base16 -a "(__base16_schemes)" -d "Color scheme name"

function base16 -d "Activate base16 terminal color scheme" -a scheme_name -a skip_env
    if not status --is-interactive
        echo "base16 doing nothing: non interactive shell"
        return
    end

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

    if test -z "$scheme_name"
        echo "base16 cancelled"
        return 1
    end

    set -l scheme_script "$__base16_path/base16-$scheme_name.sh"

    if not test -e "$scheme_script"
        echo "base16 error: $scheme_name not found"
        return 1
    end

    if test "$__base16_scheme_script" != "$scheme_script"
        set -g __base16_scheme_script $scheme_script

        if test -z "$skip_env"
            set -gx BASE16_THEME {$scheme_name}
        end

        source {$DOTFILES_RESOURCES}/base16-fzf/fish/base16-{$scheme_name}.fish

        if type -q vivid
            set -gx LS_COLORS (vivid generate base16-{$scheme_name})
        end
    end

    return 0
end

function auto_gruv -d "Auto Gruv" -e fish_prompt
    if not status --is-interactive
        return
    end

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

