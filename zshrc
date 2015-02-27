DOTFILE_RESOURCES=$HOME/.dotfiles/Resources
HISTSIZE=5000
SAVEHIST=10000
HISTFILE=~/.zsh_history
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
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' \
  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

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

bindkey -v
export KEYTIMEOUT=1 # may cause issues with other commands, but reduces delay when hitting esc
if [[ "$TERM" != emacs ]] ; then
    [[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  up-line-or-history
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
    # ncurses stuff:
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history
fi

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
      print -n "\e]50;CursorShape=0\a"
      VIM_PS1="⌨ "
      ;;
    viins|main)
      print -n "\e]50;CursorShape=1\a"
      VIM_PS1="  "
      ;;
  esac
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

autoload -U colors && colors
PS1='%(1j.[%F{green}%j%f].)%S%(!.%F{red}.%F{blue})│%m│%s%f$VIM_PS1'

autoload -Uz vcs_info
RPS1='${vcs_info_msg_0_}%S %3~ %s'

# customize vcs info on prompt
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
zstyle ':vcs_info:*' formats       "%F{blue}%s%f %K{green} %b┃%k" 'zsh: %r'
zstyle ':vcs_info:*' actionformats "%F{blue}%s%f %K{red} %a┃%K{green} %b┃%k" 'zsh: %r'

# Put the penultimate and current directory in the iterm tab:
function settab { print -Pn "\e]1;%2~\a" }

# Put the string "hostname:/full/directory/path" in the title bar:
function settitle { print -Pn "\e]2;%n@%m:%d\a" }

function make_light { print -n "\e]50;SetProfile=light\a" }
function make_dark  { print -n "\e]50;SetProfile=dark\a" }

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
    xsource "${HOME}/.zsh/mac.zsh"
fi
xsource "${HOME}/.zsh/${HOST%%.*}.zsh"
xsource $HOME/.zsh/*.plugin.zsh

xsource "$DOTFILE_RESOURCES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$DOTFILE_RESOURCES/git-flow-completion/git-flow-completion.zsh"

# fasd
eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pass password store
export PASSWORD_STORE_DIR=~/Dropbox/.password-store
