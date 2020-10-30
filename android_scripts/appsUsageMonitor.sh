#!/bin/bash
while true; do
	echo $(. getAppsUsage.sh $1) >> data.txt
	sleep 10
done