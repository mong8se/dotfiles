function base16 -d "activate base16 color scheme"
  set -l light_or_dark "dark"
  set -l base16 $HOME/.dotfiles/Resources/base16-shell

  switch (count $argv)
  case 0
    ls $base16/*.dark.sh | cut -d . -f 2 | cut -d - -f 3
    exit
  case 1
  case 2
    set light_or_dark $argv[2]
    echo $light_or_dark
  case '*'
    echo "base16 scheme [light_or_dark]"
    exit
  end

  eval sh {$base16}/base16-{$argv[1]}.{$light_or_dark}.sh
end
