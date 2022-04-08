function task -d "Run task from local or home Taskfile"
  if test -f ./Taskfile
    set -f Taskfile ./Taskfile
  else if test (pwd) = ~
    set -f Taskfile ~/.dotfiles/Taskfile
  else
    echo "Taskfile not found."
    return
  end

  bash "$Taskfile" $argv
end
