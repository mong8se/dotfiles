# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Dynamic-named-directories

function __vcs_root_named_directory ()
{
  if [[ $1 = d ]]; then
    vcs_info __vcs_root
    if [ $vcs_info_msg_0_ ]; then
      typeset -ga reply
      reply=($vcs_info_msg_1_ ${#vcs_info_msg_0_})
      vcs_info
      return
    fi
  fi
  return 1
}

zstyle ':vcs_info:*:__vcs_root:*' formats '%R' '%r'
zstyle ':vcs_info:*:__vcs_root:*' actionformats '%R' '%r'
zsh_directory_name_functions+=(__vcs_root_named_directory)
