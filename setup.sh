#!/bin/bash
# Usage: ./setup.sh
# Connect to all devices listed in IP`s.txt and start the monitoring of the apps in apps.txt

# check if configuration files exists
if [ ! -f IPs.txt ]; then
    echo "Please create a file named 'IPs.txt' containing all IPs you wish to connect to."
    echo "File not found: IPs.txt"
    exit 1
fi

if [ ! -f apps.txt ]; then
    echo "Please create a file named 'apps.txt' containing all the apps you wish to monitor."
    echo "File not found: apps.txt"
    exit 1
fi

_apps=$(cat apps.txt)
apps=`echo $_apps | sed 's/\\r//g'` # remove \r\n line ending

# Connect to devices
for IP in $(cat IPs.txt); do
    android_IP=`echo $IP | sed 's/\\r//g'`
    
    result=$(adb connect $android_IP)
    # adb does not throw an error if it cannot connect
    # so it must be checked manually
    if [[ $result == *"cannot connect"* ]]; then 
        echo "Could not connect to $android_IP"; 
        continue; 
    fi
    # push the necessary scripts to the android device and start running the monitor
    adb -s $android_IP push android_scripts/ /sdcard/
    nohup adb -s $android_IP shell android_scripts/startAppsMonitor $apps & disown
    echo "IP: $IP \t PID: $!" >> PIDs.txt # save the process PID to kill it later
done;