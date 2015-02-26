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

# Completions
autoload -Uz compinit
compinit

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
if [[ "$TERM" != emacs ]] ; then
    [[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  up-line-or-history
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
    # ncurses stuff:
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history
fi

function zle-line-init zle-keymap-select {
    VIM_MODE_PROMPT="${${KEYMAP/vicmd/C}/(main|viins)/I}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

function vim_mode_prompt {
    if [[ "$VIM_MODE_PROMPT" == 'C' ]]
    then echo '⌨ '
    else echo '⟩ '
    fi
    VIM_MODE_PROMPT='I'
}

autoload -U colors && colors
PS1='%(1j.[%F{green}%j%f].)%S%(!.%F{red}.%F{blue}) %m %s┃%f$(vim_mode_prompt)'

autoload -Uz vcs_info
RPS1='${vcs_info_msg_0_}%S %3~ %s'

# customize vcs info on prompt
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
zstyle ':vcs_info:*' formats       "%F{blue}%s%f %K{green} %b %k%%S┃%%s" 'zsh: %r'
zstyle ':vcs_info:*' actionformats "%F{blue}%s%f %K{red} %a %K{green}%F{red}┃%f %b %k%%S┃%%s" 'zsh: %r'

# Put the penultimate and current directory in the iterm tab:
function settab { print -Pn "\e]1;%m:%2~\a%" }

# Put the string "hostname:/full/directory/path" in the title bar:
function settitle { print -Pn "\e]2;%n@%m:%d\a" }

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
