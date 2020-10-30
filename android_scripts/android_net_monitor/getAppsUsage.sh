#!/bin/bash
# Get android app network usage statistics.
# Usage: ./getAppsUsage.sh "uid1;uid2;..."

function getAppsUsage()
{
	pat=$(cat /sdcard/android_net_monitor/UIDs.txt) # uids to search for while reading the stats file

	for i in $(echo $pat | tr '|' '\n'); do
		uids[$i]=0
	done

	# /proc/net/xt_qtaguid/stats is the file where network usage data is stored
	for bytes in $(cat /proc/net/xt_qtaguid/stats | grep -E "${pat}" | 
				   cut -d " " -f 4,6,8| tr ' ' ';');
	do
		# get the uids and corresponding bytes
		IFS=";" read uid rx tx <<< "$bytes"
		b=$((rx + tx)) # total bytes sent and received
		uids[$uid]=$((uids[$uid] + $b))
	done;

	result=$(date +"%D %T")
	for key in ${!uids[@]}; do
		result="${result} ${key} ${uids[${key}]}"
	done;
	echo $result
};

getAppsUsage $1