#!/usr/bin/python

from mininet.net import Mininet
from mininet.node import  Controller, RemoteController, OVSKernelSwitch, OVSSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel
from mininet.link import TCLink
import aps
import os
import argparse
import time
import pickle

def topology():
	"Create a network."
	net = Mininet( controller=RemoteController, link=TCLink, switch=OVSKernelSwitch )

	os.system('clear')
	parser = argparse.ArgumentParser(description='Compute Access Points over-reservation.')
	parser.add_argument("-aps", metavar='APs', type=int, default=6, help='amount of aps (default: 6)')
	parser.add_argument("-cosA", metavar='MOs', type=int, default=0, help='amount of MOs in CoS A (default: 0)') # TBD
	parser.add_argument("-cosB", metavar='MOs', type=int, default=0, help='amount of MOs in CoS B (default: 0)') # TBD
	parser.add_argument("-cosC", metavar='MOs', type=int, default=0, help='amount of MOs in CoS C (default: 0)') # TBD
	args = parser.parse_args()

	print "*** Starting Simulation..."
	time.sleep(1)

	print "*** Starting Controller"
	c0 = net.addController('c0', controller=RemoteController, ip='127.0.0.1', port=6633 )								# Add Controller
	s0 = net.addSwitch( 's0' )
	s11 = net.addSwitch( 's11' )
	s12 = net.addSwitch( 's12' )
	sc1 = net.addSwitch( 'sc1' )
	sc2 = net.addSwitch( 'sc2' )
	sc3 = net.addSwitch( 'sc3' )
	sc4 = net.addSwitch( 'sc4' )
	sc5 = net.addSwitch( 'sc5' )
	sc6 = net.addSwitch( 'sc6' )
	ap0 = net.addBaseStation( 'ap0', ssid= 'ssid_0', mode= 'g', channel= '1' )

	sta0 = net.addStation( 'sta0', ip="10.0.100.1")
	sta00 = net.addStation( 'sta00', ip="10.0.100.2")
	sta000 = net.addStation( 'sta000', ip="10.0.100.3")
        
	print "*** Creating PoAs"	# Cria e faz bootstrapping dos PoAs
	for i in range(1, args.aps+1):
		print("\nCreating AP"+str(i)+"...")
		
		globals()['ap%s' % i] =  net.addBaseStation( 'ap'+str(i), ssid="ssid_"+str(i), mode="g", channel="1" )	# Add AP/PoA   -> ap1 = net.addBaseStation
		globals()['ap%s' % i].start( [c0] )																		# Start AP/PoA -> ap1.start( [c0] )
		print("Bootstrapping PoA"+str(i)+"...")
		print("Displaying PoA Pool"+"...")

	# Definicao da quantidade de MOs em cada CoS
	print "***Initializing scenario" 
	cosA_MO = 1 # amount of MO in the CoSA
	cosB_MO = 1
	cosC_MO = 1
	cosX_MO = [cosC_MO, cosB_MO, cosA_MO]
	mn = 1
	sta_list = []

	# Scenario initialization - Criacao de todos os Stations (Necessario antes de addLink)
	print "*** Creating nodes"
	for mo in cosX_MO: 
		for m in range(1, mo+1):
			mo_name = 'sta'+str(mn)
			if (mn == 1):
				globals()['sta%s' % mn] = net.addStation( mo_name, ip="10.0.0."+str(mn), wlans=2 )      
			else:
				globals()['sta%s' % mn] = net.addStation( mo_name, ip="10.0.0."+str(mn) )      
			sta_list.append("sta"+str(mn))
			mn += 1
	print sta_list

	# Initializes scenario in AP0
	mn = 1
	for mo in cosX_MO:
		for m in range(1, mo+1):
			mo_name = 'sta'+str(mn)
			net.addLink(sta_list[mn-1], ap0)
			sta = globals()['sta%s' % mn]
			sta.cmdPrint("sudo python ./scripts/server.py -ip 10.0.0."+str(mn)+" -p 8088 &")
			sta.cmdPrint("sudo ./scripts/iperf_client.sh &")
			mn += 1

	print "*** Creating link between devices"
#	for poa in range(1, args.aps+1):
#		net.addLink(globals()['ap%s' % poa], s0)

	print "*** Adding link between devices"
	net.addLink(sc6, ap6)
	net.addLink(sc6, ap5)
	net.addLink(sc6, ap4)
	net.addLink(sc5, ap3)
	net.addLink(sc5, ap2)
	net.addLink(sc5, ap1)
	net.addLink(sc3, sc4)
	net.addLink(sc1, sc3)
	net.addLink(s12, sc3)
	net.addLink(s12, sc1)
	net.addLink(sc4, sc6)
	net.addLink(sc2, sc4)
	net.addLink(sc2, sc1)
	net.addLink(s11, sc1)
	net.addLink(sc5, ap0)
	net.addLink(sc2, sc5)
	net.addLink(s11, sc2)
	net.addLink(s0, sc2)
	net.addLink(s11, s0)

#	net.addLink(sta0, s0)
#	net.addLink(sta00, s11)
#	net.addLink(sta000, s11)

	print "*** Starting network"
	net.build()
	c0.start()
	s0.start( [c0] )
	s11.start( [c0] )
	sc2.start( [c0] )
	sc5.start( [c0] )
	sc1.start( [c0] )
	sc4.start( [c0] )
	sc6.start( [c0] )
	s12.start( [c0] )
	sc3.start( [c0] )
	ap0.start( [c0] )
	ap1.start( [c0] )
	ap2.start( [c0] )
	ap3.start( [c0] )
	ap4.start( [c0] )
	ap5.start( [c0] )
	ap6.start( [c0] )

	print "*** Running CLI"
	CLI( net )

	print "*** Stopping network"
	net.stop()

if __name__ == '__main__':
	setLogLevel( 'info' )
	topology()
