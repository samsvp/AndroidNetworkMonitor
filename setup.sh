#!/bin/bash
# Usage: ./setup.sh
# Connect to all devices listed in IP`s.txt and pass the UIDs of the apps
# listed on android_scripts/apps.txt

# check if configuration files exists
if [ ! -f IPs.txt ]; then
    echo "Please create a file named 'IPs.txt' containing all IPs you wish to connect to."
    echo "File not found: IPs.txt"
    exit 1
fi

# check if apps files exists
if [ ! -f android_scripts/apps.txt ]; then
    echo "Please create a file named 'apps.txt' inside 'android_scripts/'."
    echo "It should contain all apps you wish to monitor."
    echo "File not found: apps.txt"
    exit 1
fi

if [ -f nohup.out ]; then
    rm nohup.out
fi

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
    adb -s $android_IP push android_scripts/android_net_monitor/ /sdcard/ 

    # get UIDs
    android_scripts/getAppsUID.sh
    adb -s $android_IP push android_scripts/UIDs.txt /sdcard/android_net_monitor/
    adb -s $android_IP push android_scripts/apps.txt /sdcard/android_net_monitor/

    # start monitoring
    adb -s $android_IP shell "sh /sdcard/android_net_monitor/appsUsageMonitor.sh"
done;