# AndroidNetworkMonitor
Collection of scripts to monitor Android apps network usage with data.

## Dependencies
Linux:
```
sudo apt install adb
```

Windows:
Download and install ADB and Cygwin.

## Usage
Create a file named "IPs.txt" containing the list of android IPs you wish to connect to.
E.g.
```
192.168.0.100
192.168.0.125
```

Then create a file named "apps.txt" containing the list of the name of the android apps you wish to monitor.
The apps name must end with a semicolon and the file must have only one line.
E.g.
```
netflix;hulu;amazon;
```

Note: To be able to access the apps network data we first acces its package name. Some apps, however, do not have its name in its package name (GMail is sometimes identified as "com.google.gm", for example). In this case run `adb -s <device_IP> shell pm list packages` and check what is the name of your app in the package.

Afterwards run 
```
./setup.sh
```
The monitoring will start. A "data.txt" file will be created inside android's sdcard in the folder 
android_scripts. A PIDs.txt file will also be created. When you wish to finish the monitoring
run `adb -s <device_IP> shell kill -9 <PID>` where "PID" is the script's PID inside PIDs.txt.