if type -q fre
  function __fre_run -e fish_postexec
    set -l last_status $status
    if test $last_status -eq 0
      set -l last_cmd (string split " " $argv[1])[1]
      if test "cd" = "$last_cmd"
        command fre --add "$PWD" &; disown
      end
    end
  end

  function z
    set -l result
    if count $argv > "/dev/null"
      set result (command fre --sorted | rg -v "^$(pwd)\$" | fzf -f "$argv" | head -1)
      set -xg __fre_last_argv "$argv"
    else
      set result (command fre --sorted | fzf)
    end

    test -z "$result"; and return
    test -d "$result"; and cd "$result"
  end

  function zz
    z "$__fre_last_argv"
  end
else if type -q zoxide
  zoxide init fish --no-aliases | source
  function z
    if count $argv > /dev/null
      set -xg __zoxide_last_argv $argv
      __zoxide_z $argv
    else
      __zoxide_zi
    end
  end
  function zz
    __zoxide_z $__zoxide_last_argv
  end
else if type -q fasd
  if type -q disown
    function __fasd_run --on-variable PWD
      command fasd --proc (command fasd --sanitize "$argv" | tr -s ' ' \n) >/dev/null 2>&1 &
      disown
    end
  else
    function __fasd_run --on-variable PWD
      command fasd --proc (command fasd --sanitize "$argv" | tr -s ' ' \n) >/dev/null 2>&1 &
    end
  end

  function __fasd_query
    if count $argv > /dev/null
      command fasd -dl1 "$argv"
    else
      command fasd -dlR | fzf
    end
  end
  function z
    set -l result (__fasd_query $argv)
    test -z "$result"; and return
    test -d "$result"; and cd "$result"
  end
end
