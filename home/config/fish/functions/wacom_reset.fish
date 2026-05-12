#!/usr/bin/env fish

function wacom_reset -d "Restart Wacom Driver"
    # killall WacomTabletDriver
    echo -n "Restarting Wacom Driver ..."
    "/Applications/Wacom Tablet.localized/Wacom Tablet Utility.app/Contents/MacOS/Wacom Tablet Utility" --restart
    echo "... Done."
end
