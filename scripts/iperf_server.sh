#!/bin/bash


for i in `seq 1 $1`
do
	#iperf -c 10.0.0.$i -u -b 3m -t 10000 &
	iperf -c 10.0.0.$i -u -b 2m -t 1000 &
done

#iperf -s -u
