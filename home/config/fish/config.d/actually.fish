function actually -e fish_postexec
  set -f last_status $status
  if test $last_status -gt 0
    set -f last_cmd (string split " " $argv[1])
    if test "cd" = "$last_cmd[1]"
      # using string replace to do tilde expansion manually, not sure if there is a way
      # to get it to work automatically when inside a variable from a split string
      set -f last_dir (path dirname $last_cmd[2] | string replace -r '^~' "$HOME")
      set -f last_base (path basename $last_cmd[2])
      set -l list (command find "$last_dir" -maxdepth 1 -mindepth 1 -name "$last_base"'*' | path sort)

      if test "$list" = ""
        return
      end

      set -l i 1
      set_color blue
      echo um ... actually, you probably meant:
      set_color normal
      for dir in $list
        echo $i $dir
        set i (math $i + 1)
      end
      set -l answer (read -n 1 -p 'set_color green; echo -n "> " ; set_color normal')
      if string match -r '^\d+$' "$answer"; and test -n "$list[$answer]" -a -d "$list[$answer]"
        cd "$list[$answer]"
      else
        echo nevermind
        return 1
      end
    end
  end
end
