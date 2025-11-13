status is-interactive || exit

if type -q fre
  function __fre_run --on-variable PWD
    if test -n "$fish_private_mode" -o "$PWD" = "$HOME"
      return
    end
    command fre --add "$PWD" &
    disown
  end

  if not set -q __z_fzf_args
    set -g __z_fzf_args --nth=-2.. -d / --tiebreak end,length,index --no-sort --smart-case --exact --scheme=path
  end

  function __z_query
    set -f result (
    begin
      command fre --sorted
      command find $Z_FALLBACKS -maxdepth 1 -mindepth 1 -type d -print
    end |
    string match -v (pwd) |
    if count $argv > "/dev/null"
      fzf $__z_fzf_args -f "$argv" | head -1
    else
      fzf $__z_fzf_args
    end
    )

    test -z "$result"; and return
    if test -d "$result"
      cd "$result"
    else
      command fre --delete "$result" &
      disown
    end
  end
else if type -q zoxide
  zoxide init fish --no-aliases | source
  function __z_query
    if count $argv >/dev/null
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
    if count $argv >/dev/null
      command fasd -dl1 "$argv"
    else
      command fasd -dlR | fzf
    end
  end
  function __z_query
    set -f result (__fasd_query $argv)
    test -z "$result"; and return
    test -d "$result"; and cd "$result"
  end
end

function z
  if test "$argv" = "-"
    cd -
    return
  end

  set -g __z_last_arg $argv
  __z_query $argv
end

function zz
  __z_query $__z_last_arg
end
