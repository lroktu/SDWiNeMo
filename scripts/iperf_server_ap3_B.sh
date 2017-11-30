#!/bin/bash


for i in `seq 16 16`
do
	#iperf -c 10.0.0.$i -u -b 3m -t 10000 &
	iperf -c 10.0.0.$i -b 1m -t 1000 &
done


#iperf -s -u
