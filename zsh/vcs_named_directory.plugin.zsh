# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Dynamic-named-directories

zstyle ':vcs_info:*:__vcs_root:*' formats '%R'
zstyle ':vcs_info:*:__vcs_root:*' actionformats '%R'
zsh_directory_name_functions+=(__vcs_root_named_directory)

function __vcs_root_named_directory ()
{
  local result=1
  case "$1" in
    d)
      # from directory to name
      vcs_info __vcs_root
      if [ $vcs_info_msg_0_ ]; then
        typeset -ga reply
        reply=(${vcs_info_msg_0_##*/} ${#vcs_info_msg_0_})
        result=0
      fi
      ;;
    n)
      # TODO: not sure if we can go from name to directory
      # without defining some sort of base path like ~/Projects
      ;;
    c)
      # TODO: not sure how to do a completion on a name
      # without defining some sort of base path like ~/Projects
      ;;
    *)
      # here be dragons
      ;;
  esac
  if [ $result -eq 0 ]; then
    vcs_info
  fi
  return $result
}
