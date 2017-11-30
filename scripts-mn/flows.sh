#!/bin/bash

sta0="2e:5b:a1:52:35:44"
sta1="02:00:00:00:09:00"
pri="60001"
staX="10.0.0.1"
staY="10.0.100.1"

ovs-ofctl del-flows s1
ovs-ofctl del-flows ap0
ovs-ofctl del-flows ap1
ovs-ofctl del-flows ap2
ovs-ofctl del-flows ap3

# Fluxos para os APS
ovs-ofctl add-flow ap0 "idle_timeout=1800,priority="$pri",nw_dst="$staX",in_port=1,actions=output:2"
ovs-ofctl add-flow ap0 "idle_timeout=1800,priority="$pri",nw_src="$staX",in_port=2,actions=output:1"
ovs-ofctl add-flow ap1 "idle_timeout=1800,priority="$pri",in_port=1,actions=output:2"
ovs-ofctl add-flow ap1 "idle_timeout=1800,priority="$pri",in_port=2,actions=output:1"
#ovs-ofctl add-flow ap2 "idle_timeout=1800,priority="$pri",nw_dst="$staX",in_port=1,actions=output:2"
#ovs-ofctl add-flow ap2 "idle_timeout=1800,priority="$pri",nw_src="$staX",in_port=2,actions=output:1"
ovs-ofctl add-flow ap3 "idle_timeout=1800,priority="$pri",nw_dst="$staX",in_port=1,actions=output:2"
ovs-ofctl add-flow ap3 "idle_timeout=1800,priority="$pri",nw_src="$staX",in_port=2,actions=output:1"


ovs-ofctl add-flow ap4 "idle_timeout=1800,priority="$pri",nw_dst="$staX",in_port=1,actions=output:2"
ovs-ofctl add-flow ap4 "idle_timeout=1800,priority="$pri",nw_src="$staX",in_port=2,actions=output:1"

ovs-ofctl add-flow ap5 "idle_timeout=1800,priority="$pri",nw_dst="$staX",in_port=1,actions=output:2"
ovs-ofctl add-flow ap5 "idle_timeout=1800,priority="$pri",nw_src="$staX",in_port=2,actions=output:1"

ovs-ofctl add-flow ap6 "idle_timeout=1800,priority="$pri",nw_dst="$staX",in_port=1,actions=output:2"
ovs-ofctl add-flow ap6 "idle_timeout=1800,priority="$pri",nw_src="$staX",in_port=2,actions=output:1"



# Insere fluxos no switch
ovs-ofctl add-flow s1 "idle_timeout=1800,priority="$pri",nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:7"
ovs-ofctl add-flow s1 "idle_timeout=1800,priority="$pri",nw_src="$staX",nw_dst="$staY",in_port=7,actions=output:8"

