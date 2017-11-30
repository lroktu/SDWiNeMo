#!/bin/bash
#
# Client

#rm rd_a01
ufw enable
tcpdump -i any -n -tt -v udp port 12345 > rd_a01 
