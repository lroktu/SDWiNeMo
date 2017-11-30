#!/bin/bash

sudo ifconfig lo:1 down

sudo ifconfig s1 10.0.0.11 up
sudo ifconfig s2 10.0.0.12 up
sudo ifconfig s3 10.0.0.13 up
sudo ifconfig s4 10.0.0.14 up
sudo ifconfig s5 10.0.0.15 up

sudo route add 10.0.0.1 dev s1
sudo route add 10.0.0.2 dev s2
sudo route add 10.0.0.3 dev s3
sudo route add 10.0.0.4 dev s4
sudo route add 10.0.0.5 dev s5
