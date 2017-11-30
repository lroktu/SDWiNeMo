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
    s1 = net.addSwitch( 's1', listenPort=6673, mac='00:00:00:00:00:01' )
    s2 = net.addSwitch( 's2', listenPort=6674, mac='00:00:00:00:00:02' )
    s3 = net.addSwitch( 's3', listenPort=6675, mac='00:00:00:00:00:03' )
    h1 = net.addHost( 'h1' )
    h2 = net.addHost( 'h2' )

    print "*** Creating links"
    net.addLink(s2, s3)
    net.addLink(s1, s3)
    net.addLink(s2, s1)
    net.addLink(s2, h1)
    net.addLink(s3, h2)

    print "*** Starting network"
    net.build()
    c1.start()
    s1.start( [c1] )
    s2.start( [c1] )
    s3.start( [c1] )

    print "*** Running CLI"
    CLI( net )

    print "*** Stopping network"
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    topology()

