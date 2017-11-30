#!/bin/bash

#IFACE=`iwconfig 2>&1 | grep IEEE | awk '{print $1}'`
IFACE="sta1-wlan0"
iw dev $IFACE disconnect
iw dev $IFACE connect $1

