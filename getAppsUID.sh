#!/bin/bash
# Get android app UID
# Usage: ./getAppsUID.sh "app1;app2;..."

function getAppsUID()
{
    if [ -f UIDs.txt ]; then
        rm UIDs.txt
    fi
    
    # apps to search for while reading the stats file
    IFS=";" read -ra ADDR <<<"$1"
	apps=$(echo ${ADDR[@]}|tr " " "|") # uids to search for while reading the stats file

    for package in $(adb shell pm list packages | grep -E "${apps}" | cut -f2 -d":");
	do
        pkg=`echo $package | sed 's/\\r//g'` # remove \r\n line ending
        uid=$(adb shell dumpsys package $pkg | grep userId= | cut -f2 -d"=")";"
        echo -n `echo $uid | sed 's/\\r//g'` >> UIDs.txt
    done;
    cat UIDs.txt
};

getAppsUID $1