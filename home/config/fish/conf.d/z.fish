status is-interactive || exit

if type -q fre
  function __fre_run -e fish_postexec
    set -f last_status $status
    if test $last_status -eq 0
      set -f last_cmd (string split " " $argv[1])[1]
      if test "cd" = "$last_cmd"
        command fre --add "$PWD" &; disown
      end
    end
  end

  if not set -q __z_fzf_args
    set -g __z_fzf_args --nth=-2.. -d / --tiebreak end,length,index --no-sort -i --exact --scheme=path
  end

  function z
    set -f result (
      begin
        command fre --sorted
        command find $Z_FALLBACKS -maxdepth 1 -mindepth 1 -type d -print
        # command find $HOME -maxdepth 2 -mindepth 2 ! -path "$HOME/.*" -type d  -print
      end \
      | string match -v (pwd) \
      | if count $argv > "/dev/null"
          fzf $__z_fzf_args -f "$argv" | head -1
        else
          fzf $__z_fzf_args
        end
    )

    test -z "$result"; and return
    if test -d "$result"
      command fre --add "$PWD" &; disown
      cd "$result"
    else
      command fre --delete "$result" &; disown
    end
  end
else if type -q zoxide
  zoxide init fish --no-aliases | source
  function z
    if count $argv > /dev/null
      __zoxide_z $argv
    else
      __zoxide_zi
    end
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
    set -f result (__fasd_query $argv)
    test -z "$result"; and return
    test -d "$result"; and cd "$result"
  end
end
