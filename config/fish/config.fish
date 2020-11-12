#!/usr/bin/env fish

if not set -q hostname
    set -g hostname (hostname -s)
end

function fish_greeting
    if type -P (which figlet) >/dev/null
        and test -x (which figlet)
        set_color red
        figlet -c -w $COLUMNS -f smslant $hostname
        set_color normal
    end
end

if test (which nvim)
    set -x EDITOR (which nvim)
    set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
else
    set -x EDITOR (which vim)
end

function _run_fasd -e fish_preexec
    fasd --proc (fasd --sanitize "$argv") >"/dev/null" 2>&1
end

function z
    if count $argv >/dev/null
        cd (fasd -dl1 "$argv")
    else
        cd (fasd -dlR | fzf)
    end
end

function fv
    fzf -m --query="$argv[1]" --select-1 --exit-0 | xargs -o $EDITOR
end

function xsource -d "Source list of files if they exist."
    for file in $argv
        if test -f "$__fish_config_dir/$file"
            source "$__fish_config_dir/$file"
        end
    end
end

if status --is-interactive
    if set -q VIM_TERMINAL
        fish_default_key_bindings
    else if type -q fish_hybrid_key_bindings
        fish_hybrid_key_bindings
    else
        fish_vi_key_bindings
    end

    abbr -a gls git ls-files
    if string match --quiet '*nvim' "$EDITOR"
        abbr -a vi nvim
        if test (which abduco)
          abbr -a av abduco -A nvim nvim
        end
    end
    abbr -a em emacsclient
    abbr -a cd.. cd ..
    if set -q KITTY_WINDOW_ID
      alias icat="kitty +kitten icat"
      alias kg="kitty +kitten hyperlinked_grep"
    end

    # Feature Switches
    # if set -q ITERM_PROFILE
    # set -x HAS_UTF 0
    # set -x fish_emoji_width 2
    # else if set -q KITTY_WINDOW_ID
    set -e HAS_UTF
    # end

    # Set Base16 Shell Colors
    base16 gruvbox-dark-soft false

    set -x fish_color_error brred --italics
    set -x fish_color_autosuggestion brblack --italics

    # Base16 Gruvbox dark, soft
    # Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
    set -l color00 '#32302f'
    set -l color01 '#3c3836'
    set -l color02 '#504945'
    set -l color03 '#665c54'
    set -l color04 '#bdae93'
    set -l color05 '#d5c4a1'
    set -l color06 '#ebdbb2'
    set -l color07 '#fbf1c7'
    set -l color08 '#fb4934'
    set -l color09 '#fe8019'
    set -l color0A '#fabd2f'
    set -l color0B '#b8bb26'
    set -l color0C '#8ec07c'
    set -l color0D '#83a598'
    set -l color0E '#d3869b'
    set -l color0F '#d65d0e'

    if test (which fd)
      set -x FZF_DEFAULT_COMMAND 'fd --type f --no-ignore'
      set -x FZF_CTRL_T_COMMAND 'fd --type f . "$dir"'
    end
    set -x FZF_DEFAULT_OPTS "
  --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
  --height 40% --reverse --extended --cycle
  "

end

if test (uname) = "Darwin"
    set -x IS_MAC 0
    xsource mac.fish
end

starship init fish | source

xsource _machine.fish local.fish
