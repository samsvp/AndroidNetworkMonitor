#!/bin/bash
# Get android app UID
# Usage: ./getAppsUID.sh "app1;app2;..."

function getAppsUID()
{    
    if [ -f android_scripts/UIDs.txt ]; then
        rm android_scripts/UIDs.txt
    fi

    # apps to search for while reading the stats file
    _apps=$(cat android_scripts/apps.txt)
    echo $_apps
    apps=$(echo $_apps | tr ";" "|") # uids to search for while reading the stats file

    if [[ $apps == *"|" ]]; then
        apps=${apps%?}
    fi

    echo $apps >> debug.txt

    for package in $(adb shell pm list packages | grep -E "${apps}" | cut -f2 -d":");
	do
        pkg=`echo $package | sed 's/\\r//g'` # remove \r\n line ending
        uid=$(adb shell dumpsys package $pkg | grep userId= | cut -f2 -d"=")"|"
        
        echo $pkg $uid >> debug.txt
         # the user ID might be returned more than once for some apps
        if [[ $(echo $uid) == *" "* ]]; then
            uid=$(echo $uid | cut -f1 -d" ")"|"
            echo "new uid:" $uid >> debug.txt
        fi
        
        echo -n `echo $uid | sed 's/\\r//g'` >> android_scripts/UIDs.txt
    done;
    truncate -s-1 android_scripts/UIDs.txt # remove the last char
};

getAppsUID