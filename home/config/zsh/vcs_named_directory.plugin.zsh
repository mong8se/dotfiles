# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Dynamic-named-directories

function __vcs_root_named_directory ()
{
  if [[ $1 = d ]]; then
    vcs_info __vcs_root
    local result=0
    if [ $vcs_info_msg_0_ ]; then
      if [[ "$vcs_info_msg_0_" == "$2" || "$vcs_info_msg_0_/$vcs_info_msg_1_" == "$2" ]]; then
        typeset -ga reply
        reply=(${vcs_info_msg_0_:t} ${#vcs_info_msg_0_})
      else
        # We must be inside the repo from a symlink
        result=1
      fi
      vcs_info
      return result
    fi
  fi
  return 1
}

zstyle ':vcs_info:*:__vcs_root:*' formats '%R' '%S'
zstyle ':vcs_info:*:__vcs_root:*' actionformats '%R' '%S'

autoload -Uz add-zsh-hook
add-zsh-hook -Uz zsh_directory_name __vcs_root_named_directory
