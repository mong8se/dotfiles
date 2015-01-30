DOTFILE_RESOURCES=$HOME/.dotfiles/Resources
source $DOTFILE_RESOURCES/grml-etc-core/etc/zsh/zshrc

prompt off
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
    local VIM_SIGIL='%B|%b%# '
    if [[ "$VIM_MODE_PROMPT" == 'C' ]]
    then echo "%S${VIM_SIGIL}%s"
    else echo $VIM_SIGIL
    fi
    VIM_MODE_PROMPT='I'
}

setopt prompt_subst
autoload -U colors && colors
PS1='%(1j.[%F{green}%j%f].)%S%(!.%F{red}.%F{blue}) %m %f%s$(vim_mode_prompt)'

DONTSETRPROMPT=1
RPS1='${vcs_info_msg_0_}%S %3~ %s'

# customize vcs info on prompt
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
zstyle ':vcs_info:*' formats       "%F{blue}%s%f%B|%%b%r %K{green} %b %k " 'zsh: %r'
zstyle ':vcs_info:*' actionformats "%K{red} %a %k %F{blue}%s%f%B|%%b%r %K{green} %b %k " 'zsh: %r'

# Put the penultimate and current directory in the iterm tab:
function settab { print -Pn "\e]1;%m:%2~\a%" }

# Put the string "hostname:/full/directory/path" in the title bar:
function settitle { print -Pn "\e]2;%n@%m:%d\a" }

REPORTTIME=5
TIMEFMT=$'\e]9;%J\007 \e[7m %J: %P %Mk \e[0m %U user / %S sys / %E total'

BATTERY=1

# This updates after each change of directory:
function precmd {
    vcs_info
    settab
    settitle
}

NOPRECMD=0
NOTITLE=1

unsetopt AUTO_CD # cd if no matching command
unsetopt beep

alias cd..="cd .."

if [[ `uname` == Darwin ]] then
    xsource "${HOME}/.zsh/mac.zsh"
fi
xsource "${HOME}/.zsh/${HOST%%.*}.zsh"
xsource $HOME/.zsh/*.plugin.zsh

xsource "$DOTFILE_RESOURCES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$DOTFILE_RESOURCES/git-flow-completion/git-flow-completion.zsh"

# fasd
eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pass password store
export PASSWORD_STORE_DIR=~/Dropbox/.password-store
