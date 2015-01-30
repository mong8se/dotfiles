zsh_directory_name_functions+=(__git_root_named_directory)
function __git_root_named_directory ()
{
  if [[ $1 = d ]]; then
    local top_level=$(git -C "$2" rev-parse --show-toplevel 2> /dev/null)
    if [ $top_level ]; then
      typeset -ga reply
      reply=(${top_level##*/} ${#top_level})
      return
    else
      return 1
    fi
  else
    return 1
  fi
}
