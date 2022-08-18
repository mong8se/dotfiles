function cowfig -d "Say something through a cow with fzf magic"
  if status --is-interactive
    set -l the_text "$argv[1]"

    figlet -f (figlist | string match -v '*:' | sort | fzf +m --prompt="font>" --preview 'figlet -f {} '$the_text) $the_text | cowsay -n -f (cowsay -l | rg -v : | string split ' ' | fzf --prompt="cow>" --preview 'cowsay -f {} '$the_text)
  else
    echo "cowfig doing nothing: Non interactive shell"
  end
end
