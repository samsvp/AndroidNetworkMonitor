#!/bin/bash
# Usage: ./startAppsMonitor.sh "app1;app2;..."
# Note: not all apps may have its name on its package name
./appsUsageMonitor.sh $(./getAppsUID.sh $1)