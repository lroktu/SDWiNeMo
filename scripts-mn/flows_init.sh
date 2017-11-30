#!/bin/bash

#sta0="2e:5b:a1:52:35:44"
#sta1="02:00:00:00:09:00"
pri="65530"
staX="10.0.0.1"
sta0="10.0.100.1"
sta00="10.0.100.2"



#ovs-ofctl del-flows s1
#ovs-ofctl del-flows ap0
#ovs-ofctl del-flows ap1
#ovs-ofctl del-flows ap2
#ovs-ofctl del-flows ap3

# Insere fluxos no switch - STA0 --> STA1
#ovs-ofctl add-flow s0 "dl_type=0x0800,idle_timeout=1800,priority=65535,nw_src="$staY",nw_dst="$staX",actions=CONTROLLER:65535"
ovs-ofctl add-flow s0 "dl_type=0x0800,idle_timeout=1800,priority="$pri",nw_src="$sta0",nw_dst="$sta00",in_port=10,actions=output:11"
ovs-ofctl add-flow s0 "dl_type=0x0800,idle_timeout=1800,priority="$pri",nw_src="$sta00",nw_dst="$sta0",in_port=11,actions=output:10"

# Fluxos para os AP0
#ovs-ofctl add-flow ap0 "dl_type=0x0800,idle_timeout=1800,priority="$pri",nw_src="$sta0",nw_dst="$staX",in_port=1,actions=output:2"
#ovs-ofctl add-flow ap0 "dl_type=0x0800,idle_timeout=1800,priority="$pri",nw_src="$staX",nw_dst="$sta0",in_port=2,actions=output:1"
