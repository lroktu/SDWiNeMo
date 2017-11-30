#!/bin/bash

sudo ifconfig lo:1 10.0.0.3/32
sudo mn --topo linear,5 --switch ovsk,inband=True --controller=remote,ip=10.0.0.3
