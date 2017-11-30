#!/usr/bin/python

from mininet.net import Mininet
from mininet.node import  Controller, RemoteController, OVSKernelSwitch
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
	s1 = net.addSwitch( 's1' )																							# Add Switch s1
	si1 = net.addSwitch( 'si1' )																						# Add Switch si1
	sc1 = net.addSwitch( 'sc1' )																						# Add Switch sc2
	sc2 = net.addSwitch( 'sc2' )																						# Add Switch sc2
	sc5 = net.addSwitch( 'sc5' )																						# Add Switch sc5
	ap0 = net.addBaseStation('ap0', ssid="ssid_0", mode="g", channel="1")												# Add ap0
	sta0 = net.addStation( 'sta0', ip="10.0.100.1")
	sta00 = net.addStation( 'sta00', ip="10.0.100.3")
        
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
#		net.addLink(globals()['ap%s' % poa], s1)

	print "*** Adding link between nodes and s1"
	net.addLink(sc5, ap0)
	net.addLink(si1, sc2)
	net.addLink(sc2, s1)
	net.addLink(si1, s1)
	net.addLink(sc2, sc5)
	net.addLink(si1, sc1)
	net.addLink(sc1, sc2)


	print "*** Adding link between nodes"
#	net.addLink(sc2, si1)
#	net.addLink(sc5, sc2)

	print "*** Starting network"
	net.build()
	c0.start()
	s1.start( [c0] )
	si1.start( [c0] )
	sc1.start( [c0] )
	sc2.start( [c0] )
	sc5.start( [c0] )
	ap0.start( [c0] )

	for poa in range(1, args.aps+1):
		globals()['ap%s' % poa].start( [c0] )

	print "*** Running CLI"
	CLI( net )

	print "*** Stopping network"
	net.stop()

if __name__ == '__main__':
	setLogLevel( 'info' )
	topology()
