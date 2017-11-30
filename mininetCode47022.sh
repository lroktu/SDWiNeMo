#!/usr/bin/python

"""
Script created by VND - Visual Network Description (SDN version)
"""
from mininet.net import Mininet
from mininet.node import Controller, RemoteController, OVSKernelSwitch, IVSSwitch, UserSwitch
from mininet.link import Link, TCLink
from mininet.cli import CLI
from mininet.log import setLogLevel

def topology():

    "Create a network."
    net = Mininet( controller=RemoteController, link=TCLink, switch=OVSKernelSwitch )

    print "*** Creating nodes"
    c1 = net.addController( 'c1', controller=RemoteController, ip='127.0.0.1', port=6633 )
    s2 = net.addSwitch( 's2', listenPort=6673, mac='00:00:00:00:00:02' )
    s3 = net.addSwitch( 's3', listenPort=6674, mac='00:00:00:00:00:03' )
    s4 = net.addSwitch( 's4', listenPort=6675, mac='00:00:00:00:00:04' )
    ap9 = net.addBaseStation( 'ap9', ssid= 'new-ssid', mode= 'g', channel= '1' )
    s11 = net.addSwitch( 's11', listenPort=6677, mac='00:00:00:00:00:11' )
    s14 = net.addSwitch( 's14', listenPort=6678, mac='00:00:00:00:00:14' )

    print "*** Creating links"
    net.addLink(s4, s14)
    net.addLink(s3, s14)
    net.addLink(s11, ap9)
    net.addLink(s4, s11)
    net.addLink(s3, s4)
    net.addLink(s2, s4)
    net.addLink(s3, s2)

    print "*** Starting network"
    net.build()
    c1.start()
    s2.start( [c1] )
    s3.start( [c1] )
    s4.start( [c1] )
    s11.start( [c1] )
    s14.start( [c1] )
    ap9.start( [c1] )

    print "*** Running CLI"
    CLI( net )

    print "*** Stopping network"
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    topology()

