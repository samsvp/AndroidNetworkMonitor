#!/bin/bash
# Get android app network usage statistics.
# Usage: ./getAppsUsage.sh "uid1;uid2;..."
function getAppsUsage()
{
	# create a dictionary with uids
	declare -A uids

	IFS=";" read -ra ADDR <<<"$1"
	for i in "${ADDR[@]}"; do
		uids[$i]=0
	done

	pat=$(echo ${ADDR[@]}|tr " " "|") # uids to search for while reading the stats file

	for bytes in $(adb shell cat /proc/net/xt_qtaguid/stats | grep -E "${pat}" | awk '{print  $4 ";" $6 + $8}');
	do
		# get the uids and corresponding bytes
		IFS=";" read -ra arr <<<"$bytes"
		uid=${arr[0]}
		b=${arr[1]}
		uids[$uid]=$((uids[$uid] + $b))
	done;

	result=$(date +"%D %T")
	for key in ${!uids[@]}; do
		result="${result} ${key} ${uids[${key}]}"
	done;
	echo $result
};

getAppsUsage $1