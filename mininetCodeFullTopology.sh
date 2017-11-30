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
    net = Mininet( controller=Controller, link=TCLink, switch=OVSKernelSwitch )

    print "*** Creating nodes"
    c1 = net.addController( 'c1', controller=RemoteController, ip='127.0.0.1', port=6633 )
    s2 = net.addSwitch( 's2', listenPort=6673, mac='00:00:00:00:00:02' )
    s3 = net.addSwitch( 's3', listenPort=6674, mac='00:00:00:00:00:03' )
    s4 = net.addSwitch( 's4', listenPort=6675, mac='00:00:00:00:00:04' )
    ap9 = net.addBaseStation( 'ap9', ssid= 'new-ssid', mode= 'g', channel= '1' )
    s11 = net.addSwitch( 's11', listenPort=6677, mac='00:00:00:00:00:11' )
    s14 = net.addSwitch( 's14', listenPort=6678, mac='00:00:00:00:00:14' )
    s17 = net.addSwitch( 's17', listenPort=6679, mac='00:00:00:00:00:17' )
    s19 = net.addSwitch( 's19', listenPort=66710, mac='00:00:00:00:00:19' )
    s21 = net.addSwitch( 's21', listenPort=66711, mac='00:00:00:00:00:21' )
    s22 = net.addSwitch( 's22', listenPort=66712, mac='00:00:00:00:00:22' )

    ap27 = net.addBaseStation( 'ap27', ssid= 'new-ssid', mode= 'g', channel= '1' )
    ap28 = net.addBaseStation( 'ap28', ssid= 'new-ssid', mode= 'g', channel= '1' )
    ap29 = net.addBaseStation( 'ap29', ssid= 'new-ssid', mode= 'g', channel= '1' )
    ap33 = net.addBaseStation( 'ap33', ssid= 'new-ssid', mode= 'g', channel= '1' )
    ap34 = net.addBaseStation( 'ap34', ssid= 'new-ssid', mode= 'g', channel= '1' )
    ap35 = net.addBaseStation( 'ap35', ssid= 'new-ssid', mode= 'g', channel= '1' )

    print "*** Creating links"
    net.addLink(s19, ap35)
    net.addLink(s19, ap34)
    net.addLink(s19, ap33)
    net.addLink(s11, ap29)
    net.addLink(s11, ap28)
    net.addLink(s11, ap27)
    net.addLink(s22, s17)
    net.addLink(s14, s22)
    net.addLink(s21, s22)
    net.addLink(s21, s14)
    net.addLink(s17, s19)
    net.addLink(s4, s17)
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
    ap9.start( [c1] )
    s11.start( [c1] )
    s14.start( [c1] )
    s17.start( [c1] )
    s19.start( [c1] )
    s21.start( [c1] )
    s22.start( [c1] )
    ap27.start( [c1] )
    ap28.start( [c1] )
    ap29.start( [c1] )
    ap33.start( [c1] )
    ap34.start( [c1] )
    ap35.start( [c1] )

    print "*** Running CLI"
    CLI( net )

    print "*** Stopping network"
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    topology()

