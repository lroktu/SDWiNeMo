#!/bin/bash
#
# Server

rm rd_a01 sd_a01 st_a01
tcpdump -n -tt -v udp port 12345 > sd_a01 & 
