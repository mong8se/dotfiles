# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Dynamic-named-directories
zsh_directory_name_functions+=(__git_root_named_directory)
function __git_root_named_directory ()
{
  case "$1" in
    d)
      # from directory to name
      local top_level=$(git -C "$2" rev-parse --show-toplevel 2> /dev/null)
      if [ $top_level ]; then
        typeset -ga reply
        reply=(${top_level##*/} ${#top_level})
        return
      else
        return 1
      fi
      ;;
    n)
      # TODO: not sure if we can go from name to directory
      # without defining some sort of base path like ~/Projects
      return 1
      ;;
    c)
      # TODO: not sure how to do a completion on a name
      # without defining some sort of base path like ~/Projects
      return 1
      ;;
    *)
      # here be dragons
      return 1
      ;;
  esac
}
