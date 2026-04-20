if status --is-interactive
  if type -q fzf
    set -x FZF_DEFAULT_OPTS "--height 40% --reverse --extended --cycle"

    if type -q fd
      set -x FZF_DEFAULT_COMMAND 'fd --type f --no-ignore'
      set -x FZF_CTRL_T_COMMAND 'fd --type f . "$dir"'
    else if type -q rg
      set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore-vcs --hidden'
      set -x FZF_CTRL_T_COMMAND 'rg --files . "$dir"'
    end

    fzf --fish | source
  end
end
