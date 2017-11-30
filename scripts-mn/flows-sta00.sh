#!/bin/bash

sta0="2e:5b:a1:52:35:44"
sta1="02:00:00:00:09:00"
pri="60001"
staX="10.0.0.32"
staY="10.0.100.2"

#ovs-ofctl del-flows s1
#ovs-ofctl del-flows ap0
#ovs-ofctl del-flows ap1
#ovs-ofctl del-flows ap2
#ovs-ofctl del-flows ap3

# Insere fluxos no switch
ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,nw_src="$staY",nw_dst="$staX",in_port=9,actions=output:1"
ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,nw_src="$staX",nw_dst="$staY",in_port=1,actions=output:9"

# Fluxos para os APs
ovs-ofctl add-flow ap1 "priority=65535,dl_type=0x0800,idle_timeout=1800,nw_src="$staY",nw_dst="$staX",in_port=1,actions=output:2"
ovs-ofctl add-flow ap1 "priority=65535,dl_type=0x0800,idle_timeout=1800,nw_src="$staX",nw_dst="$staY",in_port=2,actions=output:1"
