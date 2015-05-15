on run argv
    tell application "System Events"
        set old_frontmost to item 1 of (get name of processes whose frontmost is true)
    end tell
    tell application "iTerm"
        activate
        set myterm to (make new terminal)
        tell myterm
            set mysession to (make new session at the end of sessions)
            tell mysession
                exec command "bash"
                write text "cd " & quoted form of (item 2 of argv) 
                write text (item 1 of argv) & " && exit" 
            end tell
            repeat while (exists myterm)
                delay 0.1
            end repeat
        end tell
    end tell
    tell application old_frontmost
        activate
    end tell
end run
