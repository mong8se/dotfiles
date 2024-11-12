function isDarkMode -d "Is Mac currently in Dark mode"
  defaults read -g AppleInterfaceStyle >/dev/null 2>&1
end

function pman -d "Open man page in Preview"
  man -t $argv | open -f -a /Applications/Preview.app
end

function rv
  fzf --query="$argv[1]" --select-1 --exit-0 | xargs -o mvim --servername (basename $PWD) --remote-silent
end

if set -q ITERM_PROFILE
  function fish_mode_prompt
  end
  test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish; or echo "iTerm2 shell extensions not installed."
end
