#!/usr/bin/env fish

if not set -q hostname
  set -g hostname (hostname -s)
end

set -x DOTFILES_RESOURCES ~/.dotfiles/Resources
set -x EDITOR (command -v nvim || command -v vim || command -v vi)
set -x BC_ENV_ARGS ~/.config/bcrc

if not set -q HOMEBREW_PREFIX
  set -l brew_path
  for test_path in /home/linuxbrew/.linuxbrew/bin/brew ~/.linuxbrew/bin/brew /usr/local/bin/brew
    if test -x $test_path
      set brew_path "$test_path"
      break
    end
  end

  if test -n "$brew_path"
    eval ($brew_path shellenv)
  end
end

if status --is-interactive
  fish_default_key_bindings

  set -x FZF_DEFAULT_OPTS "
  --height 40% --reverse --extended --cycle
  "

  if type -q fd
    set -x FZF_DEFAULT_COMMAND 'fd --type f --no-ignore'
    set -x FZF_CTRL_T_COMMAND 'fd --type f . "$dir"'
  else if type -q rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore-vcs --hidden'
    set -x FZF_CTRL_T_COMMAND 'rg --files . "$dir"'
  end

  # Set Base16 Shell Colors
  base16 gruvbox-dark-soft false

  set -x fish_color_error brred --italics
  set -x fish_color_autosuggestion brblack --italics


  function autoGrowl -d "Auto Growl" -e fish_postexec
    if test $CMD_DURATION -gt 5000
      printf "\a"
      growl finished: $argv
    end
  end

  function fv
    fzf -m --query="$argv[1]" --select-1 --exit-0 | xargs -o $EDITOR
  end

  if type -q fzf
    fzf --fish | source
  end

  if type -q starship
    function starship_transient_prompt_func
      starship module character
    end
    starship init fish | source
  end
  enable_transience

  if ! type -q fisher
    read -n 1 -p 'set_color green; echo -n "Install fisher? (y/N) " ; set_color normal' answer
    if test "$answer" = y -o "$answer" = Y
      echo Installing...
      curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    end
  end

  set -g fish_cursor_default block blink
  set -g fish_cursor_insert underscore blink
  set -g fish_cursor_visual line blink

  set -x Z_FALLBACKS ~/Projects ~/Work
end

fish_add_path ~/.cargo/bin

set -x BC_ENV_ARGS ~/.config/bcrc
set -x ASDF_DIR "$DOTFILES_RESOURCES/asdf"
set -x ASDF_DATA_DIR "$ASDF_DIR"
set -x ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY latest_installed
source $ASDF_DIR/asdf.fish
