#!/bin/bash

#1 = interface
#2 = ip
#3 = ssid

ifconfig sta45-wlan1 up
ifconfig sta45-wlan1 10.0.100.45 netmask 255.0.0.0
iw dev sta45-wlan1 connect ssid_3
