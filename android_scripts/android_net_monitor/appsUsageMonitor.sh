#!/bin/bash

while true; do
	echo $(sh /sdcard/android_net_monitor/getAppsUsage.sh) >> /sdcard/android_net_monitor/data.txt
	sleep 10
done