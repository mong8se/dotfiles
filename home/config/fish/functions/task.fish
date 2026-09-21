complete -c task -a "(task complete)" -d "Taskfile completion" --no-files

function task -d "Run task from local or home Taskfile"
    if test -f ./Taskfile
        set -f Taskfile ./Taskfile
    else if test -f ../Taskfile
        set -f Taskfile ../Taskfile
    else if test (pwd) = ~
        set -f Taskfile ~/.dotfiles/Taskfile
    else
        echo "task: Taskfile not found."
        return 1
    end

    bash "$Taskfile" $argv
end
