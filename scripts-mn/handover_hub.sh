#!/bin/bash

#IFACE=`iwconfig 2>&1 | grep IEEE | awk '{print $1}'`
#iw dev sta1-wlan0 disconnect
#ifconfig sta1-wlan0 down
iw dev sta1-wlan0 disconnect
iw dev sta1-wlan0 connect $1

