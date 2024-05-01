#!/bin/bash

# Check if GlobalProtect is running
is_running=$(launchctl list | grep -c com.paloaltonetworks.gp.pangps)

if [ $is_running -eq 0 ]; then
    echo "Starting GlobalProtect..."
    launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist
    launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangps.plist
    echo "Done!"
else
    echo "Stopping GlobalProtect..."
    launchctl remove com.paloaltonetworks.gp.pangps
    launchctl remove com.paloaltonetworks.gp.pangpa
    echo "Done!"
fi
