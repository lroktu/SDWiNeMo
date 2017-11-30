#!/bin/bash

#IFACE=`iwconfig 2>&1 | grep IEEE | awk '{print $1}'`
#iw dev $IFACE disconnect
#iw dev $IFACE connect $1

#ifconfig sta1-wlan0 down
#ifconfig sta1-wlan1 down
#iw dev sta1-wlan1 connect ssid_1

#sta0="2e:5b:a1:52:35:44"
#sta1="02:00:00:00:06:00"
#pri="65535"
#staX="10.0.0.1"
#staXX="10.0.100.222"
staY="10.0.100.1"

if [ $1 == ssid_3 ] && [ $2 == sta45 ]; then
	staX="10.0.0.45"
	staXX="10.0.100.45"
    CoS="45"
	ifconfig sta45-wlan0 down
#	ifconfig sta1-wlan1 down
#	iw dev sta1-wlan1 connect ssid_1


    # Remove Fluxos
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""

    # Adiciona Fluxos 
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=8,nw_src="$staY",nw_dst="$staX",actions=mod_dl_dst:02:00:00:00:37:00,mod_nw_dst:"$staXX",enqueue:3:"$CoS""
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=3,nw_src="$staX",nw_dst="$staY",actions=enqueue:8:"$CoS""

    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_dst="$staXX",actions=output:2"
    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_dst="$staX",actions=output:2"
    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=2,nw_src="$staX",nw_dst="$staY",actions=output:1"


elif [ $1 == ssid_1 ] && [ $2 == sta45 ]; then
    staX="10.0.0.45"
    CoS="45"
	IFACE="sta45-wlan0"
	ifconfig $IFACE up
    iw dev $IFACE disconnect
    iw dev $IFACE connect $1

	
    # Remove Fluxos
    ovs-ofctl del-flows s0 "in_port=8,nw_src=10.0.100.1,nw_dst=10.0.0.45"
    ovs-ofctl del-flows s0 "in_port=3,nw_src=10.0.100.45,nw_dst=10.0.100.1"
    ovs-ofctl del-flows ap3 "in_port=1,nw_src="$staY",nw_dst="$staX""
    ovs-ofctl del-flows ap3 "in_port=2,nw_src="$staX",nw_dst="$staY""

    # Adiciona Fluxos 
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=8,nw_src="$staY",nw_dst="$staX",actions=enqueue:1:"$CoS""
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_src="$staX",nw_dst="$staY",actions=enqueue:8:"$CoS""

    ovs-ofctl add-flow ap1 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_src="$staY",nw_dst="$staX",actions=output:2"
    ovs-ofctl add-flow ap1 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=2,nw_src="$staX",nw_dst="$staY",actions=output:1"


elif [ $2 == sta16 ]; then
	staX="10.0.0.16"
	CoS="1"
	IFACE="sta16-wlan0"
	iw dev $IFACE disconnect
	iw dev $IFACE connect $1

	# Remove Fluxos
#   ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""
#	ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""

    # Adiciona Fluxos 
	ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=8,nw_src="$staY",nw_dst="$staX",actions=enqueue:3:"$CoS""
	ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=3,nw_src="$staX",nw_dst="$staY",actions=enqueue:8:"$CoS""

	ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_src="$staY",nw_dst="$staX",actions=output:2"
	ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=2,nw_src="$staX",nw_dst="$staY",actions=output:1"

elif [ $2 == sta9 ]; then
	staX="10.0.0.9"
	CoS="2"
	IFACE="sta9-wlan0" 
	iw dev $IFACE disconnect
	iw dev $IFACE connect $1

    # Remove Fluxos
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""

    # Adiciona Fluxos 
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=8,nw_src="$staY",nw_dst="$staX",actions=enqueue:3:"$CoS""
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=3,nw_src="$staX",nw_dst="$staY",actions=enqueue:8:"$CoS""

    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_src="$staY",nw_dst="$staX",actions=output:2"
    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=2,nw_src="$staX",nw_dst="$staY",actions=output:1"

elif [ $2 == sta10 ]; then

	staX="10.0.0.10"
    CoS="2"
	IFACE="sta10-wlan0"
	iw dev $IFACE disconnect
	iw dev $IFACE connect $1


    # Remove Fluxos
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows s0 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows ap2 "dl_type=0x0800,nw_src="$staX",nw_dst="$staY""

    # Adiciona Fluxos 
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=8,nw_src="$staY",nw_dst="$staX",actions=enqueue:3:"$CoS""
    ovs-ofctl add-flow s0 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=3,nw_src="$staX",nw_dst="$staY",actions=enqueue:8:"$CoS""

    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_src="$staY",nw_dst="$staX",actions=output:2"
    ovs-ofctl add-flow ap3 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=2,nw_src="$staX",nw_dst="$staY",actions=output:1"

fi
