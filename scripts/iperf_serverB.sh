#!/bin/bash


for i in `seq 17 18`
do
	#iperf -c 10.0.0.$i -u -b 3m -t 10000 &
	iperf -c 10.0.0.$i -b 1m -t 1000 &
done

# AP3
for i in `seq 16 16`
do
    #iperf -c 10.0.0.$i -u -b 3m -t 10000 &
    iperf -c 10.0.0.$i -b 800k -t 1000 &
done

#iperf -s -u
