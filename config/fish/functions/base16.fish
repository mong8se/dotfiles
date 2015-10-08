if not set -q __base16_path
  set -g __base16_path $HOME/.dotfiles/Resources/base16-shell
end

function __base16_schemes
  ls $__base16_path/*.dark.sh | cut -d . -f 2 | cut -d - -f 3
end

function __base16_has_command
  set -l cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    return 0
  end
  return 1
end

complete -c base16 -n "not __base16_has_command" -a "(__base16_schemes)" -d "Color scheme name"
complete -c base16 -n "__base16_has_command"     -a "light dark"         -d "Color scheme version"

function base16 -d "Activate base16 terminal color scheme"
  set -l light_or_dark "dark"

  switch (count $argv)
  case 0
    echo (__base16_schemes)
    return
  case 1
  case 2
    set light_or_dark $argv[2]
  case '*'
    echo "base16 scheme [light_or_dark]"
    return
  end

  if status --is-interactive
    eval sh {$__base16_path}/base16-{$argv[1]}.{$light_or_dark}.sh
  else
    echo "base16 doing nothing: Non interactive shell"
  end
end
