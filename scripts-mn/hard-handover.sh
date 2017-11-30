#!/bin/bash

#IFACE=`iwconfig 2>&1 | grep IEEE | awk '{print $1}'`
IFACE="sta1-wlan0"

iw  $IFACE disconnect
iw  $IFACE connect $1

#ifconfig sta1-wlan0 down
#ifconfig sta1-wlan1 down
#iw dev sta1-wlan1 connect ssid_1

sta0="2e:5b:a1:52:35:44"
sta1="02:00:00:00:06:00"
pri="65535"
staX="10.0.0.1"
staXX="10.0.100.222"
staY="10.0.100.1"

if [ $1 == ssid_0 ]; then
	# Remove Fluxos
    ovs-ofctl del-flows s1 "nw_src="$staX",nw_dst="$staY""
    ovs-ofctl del-flows s1 "nw_src="$staY",nw_dst="$staX""

    # Fluxos para o Switch
	ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:7"
	ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staX",nw_dst="$staY",in_port=7,actions=output:8"

elif [ $1 == ssid_1 ]; then
	# Remove Fluxos
    ovs-ofctl del-flows s1 "nw_src="$staX",nw_dst="$staY""
    ovs-ofctl del-flows s1 "nw_src="$staY",nw_dst="$staX""

    # Fluxos para o Switch
	ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:1"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staX",nw_dst="$staY",in_port=1,actions=output:8"

elif [ $1 == ssid_2 ]; then
    # Remove Fluxos
 #   ovs-ofctl del-flows s1 "nw_src="$staX",nw_dst="$staY""
 #   ovs-ofctl del-flows s1 "nw_src="$staY",nw_dst="$staX""

    # Fluxos para o Switch

	ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:2"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staX",nw_dst="$staY",in_port=2,actions=output:8"

#	ovs-ofctl add-flow ap2 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staY",nw_dst="$staXX",in_port=1,actions=output:2"
#	ovs-ofctl add-flow ap2 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staXX",nw_dst="$staY",in_port=2,actions=mod_dl_src:02:00:00:00:09:00,mod_nw_src:"$staX",output:1"
#	ovs-ofctl add-flow ap2 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staY",nw_dst="$staX",in_port=8,actions=mod_dl_dst:02:00:00:00:0a:00,mod_nw_dst:"$staXX",output:2"
#    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staX",nw_dst="$staY",in_port=2,actions=output:8"



elif [ $1 == ssid_3 ]; then
	# Remove Fluxos
    ovs-ofctl del-flows s1 "nw_src="$staX",priority="$pri",nw_dst="$staY""
    ovs-ofctl del-flows s1 "nw_src="$staY",priority="$pri",nw_dst="$staX""

    # Fluxos para o Switch
#	ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staY",nw_dst="$staX",in_port=8,actions=mod_dl_dst:02:00:00:00:1d:00,mod_nw_dst:"$staXX",output:3"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:3"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staX",nw_dst="$staY",in_port=3,actions=output:8"

elif [ $1 == ssid_4 ]; then
    # Remove Fluxos
    ovs-ofctl del-flows s1 "nw_src="$staX",priority="$pri",nw_dst="$staY""
    ovs-ofctl del-flows s1 "nw_src="$staY",priority="$pri",nw_dst="$staX""

    # Fluxos para o Switch
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:4"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",dl_type=0x0800,nw_src="$staX",nw_dst="$staY",in_port=4,actions=output:8"

elif [ $1 == ssid_5 ]; then
    # Remove Fluxos
    ovs-ofctl del-flows s1 "nw_src="$staX",priority="$pri",nw_dst="$staY""
    ovs-ofctl del-flows s1 "nw_src="$staY",priority="$pri",nw_dst="$staX""

    # Fluxos para o Switch
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:5"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staX",nw_dst="$staY",in_port=5,actions=output:8"

elif [ $1 == ssid_6 ]; then
    # Remove Fluxos
    ovs-ofctl del-flows s1 "nw_src="$staX",priority="$pri",nw_dst="$staY""
    ovs-ofctl del-flows s1 "nw_src="$staY",priority="$pri",nw_dst="$staX""

    # Fluxos para o Switch
	ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staY",nw_dst="$staX",in_port=8,actions=output:6"
    ovs-ofctl add-flow s1 "idle_timeout=180,priority="$pri",nw_src="$staX",nw_dst="$staY",in_port=6,actions=output:8"



#	ovs-ofctl del-flows ap1 "dl_type=0x0800,nw_src="$staY",nw_dst="$staX""
#    ovs-ofctl del-flows ap1 "dl_type=0x0800,nw_src="",nw_dst="$staY""

#	ovs-ofctl add-flow ap6 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=2,nw_src="$staY",nw_dst="$staXX",actions=output:1"
#	ovs-ofctl add-flow ap6 "priority=65535,dl_type=0x0800,idle_timeout=1800,in_port=1,nw_src="$staY",nw_dst="$staY",actions=output:2"
	
fi
