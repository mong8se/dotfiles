DOTFILE_RESOURCES=$HOME/.dotfiles/Resources
ZDOTDIR=$HOME/.config/zsh
HISTSIZE=5000
SAVEHIST=10000
HISTFILE=$ZDOTDIR/history
unsetopt auto_cd
unsetopt beep
unsetopt clobber
setopt chase_dots
setopt interactive_comments
setopt append_history
setopt share_history
setopt extended_history
setopt histignorealldups
setopt histignorespace
setopt inc_append_history
setopt hist_reduce_blanks
setopt prompt_subst
setopt notify
setopt hash_list_all
setopt completeinword
setopt auto_pushd
setopt pushd_ignore_dups
setopt noglobdots
setopt noshwordsplit
setopt extended_glob
setopt correct

# Completions
autoload -Uz compinit
compinit
setopt menu_complete

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Source script if it is readable. Stolen from grml
xsource() {
    if (( ${#argv} < 1 )) ; then
        printf 'usage: xsource FILE(s)...\n' >&2
        return 1
    fi

    while (( ${#argv} > 0 )) ; do
        [[ -r "$1" ]] && source "$1"
        shift
    done
    return 0
}

function set_iterm_profile { print -n "\e]50;SetProfile=$1\a" }
function make_light { set_iterm_profile 'light' }
zle -N make_light
function make_dark  { set_iterm_profile 'dark'  }
zle -N make_dark

set -sg escape-time 0 # may cause issues with other commands, but reduces delay when hitting esc
bindkey -v
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^w' backward-kill-word
if [[ "$TERM" != emacs ]] ; then
    [[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  up-line-or-history
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
    # ncurses stuff:
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history

    bindkey -M vicmd u undo
    bindkey -M vicmd U redo
    bindkey -M vicmd gl make_light
    bindkey -M vicmd gd make_dark
fi

function zle-line-init zle-keymap-select {
  if [ $TMUX ]; then
    print -n "\ePtmux;\e"
  fi
  print -n "\e]50;CursorShape="
  case $KEYMAP in
    vicmd)
      print -n "0"
      ;;
    viins|main)
      print -n "1"
      ;;
  esac
  print -n "\a"
  if [ $TMUX ]; then
    print -n "\e\\"
  fi
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

autoload -U colors && colors
autoload -Uz vcs_info

# customize vcs info on prompt
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
zstyle ':vcs_info:*' formats       "%F{blue}%s %%S %b┃%%s%f" 'zsh: %r'
zstyle ':vcs_info:*' actionformats "%F{blue}%s %%S%F{red} %a┃%F{blue} %b┃%f%%s" 'zsh: %r'

# Put the penultimate and current directory in the iterm tab:
function settab     { print -Pn "\e]1;%2~\a" }

# Put the string "hostname:/full/directory/path" in the title bar:
function settitle   { print -Pn "\e]2;%n@%m:%d\a" }

REPORTTIME=5
TIMEFMT=$'\e]9;%J\007 \e[7m %J: %P %Mk \e[0m %U user / %S sys / %E total'

# This updates after each change of directory:
function precmd {
    settab
    settitle
}

# enable lazy mode
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias hag="history -1000 | ag "

# color ls
alias ls="ls -G "

if [[ `uname` == Darwin ]] then
    xsource $ZDOTDIR/mac.zsh
fi
xsource "$ZDOTDIR/_$(hostname -s | tr -d '\n' | /usr/bin/shasum -p -a 256 | cut -c1-12).zsh"
xsource $ZDOTDIR/*.plugin.zsh

xsource "$DOTFILE_RESOURCES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$DOTFILE_RESOURCES/git-flow-completion/git-flow-completion.zsh"

# Base16 Shell
BASE16_SHELL="$HOME/.dotfiles/Resources/base16-shell/scripts/base16-bespin.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# fasd
eval "$(fasd --init auto)"
alias v="f -e ${EDITOR:-vim}" # quick opening files with vim

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# Equivalent to above, but opens it with `open` command
fo() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && open "$file"
}

# pass password store
export PASSWORD_STORE_DIR=~/Dropbox/.password-store

# FZF defaults
export FZF_DEFAULT_OPTS='--height 40% --reverse'

eval "$(starship init zsh)"

xsource $ZDOTDIR/local.zsh
