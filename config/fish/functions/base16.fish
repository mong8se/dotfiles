if not set -q __base16_path
  set -g __base16_path $HOME/.dotfiles/Resources/base16-shell/scripts
end

function __base16_schemes
  ls $__base16_path/*.sh | perl -ne 'print "$1\n" if /^.*base16-(.+).sh$/g'
end

complete -c base16 -a "(__base16_schemes)" -d "Color scheme name"

function base16 -d "Activate base16 terminal color scheme"
  if status --is-interactive
    switch (count $argv)
    case 0
      echo (__base16_schemes)
      return
    end

    eval sh {$__base16_path}/base16-{$argv[1]}.sh
  else
    echo "base16 doing nothing: Non interactive shell"
  end
end
