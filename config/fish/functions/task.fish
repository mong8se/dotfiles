function task -d "Run task from local or home Taskfile"
  if test -f ./Taskfile
   set -f Taskfile ./Taskfile
  else
   set -f Taskfile ~/.dotfiles/Taskfile
  end

  bash "$Taskfile" $argv
end
