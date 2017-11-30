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
    c0 = net.addController( 'c0', controller=RemoteController, ip='127.0.0.1', port=6633 )
    s0 = net.addSwitch( 's0', listenPort=6673, mac='00:00:00:00:10:00' )
    s3 = net.addSwitch( 's3', listenPort=6674, mac='00:00:00:00:00:33' )
    s21 = net.addSwitch( 's21', listenPort=66711, mac='00:00:00:00:00:21' )

    sc1 = net.addSwitch( 'sc1', listenPort=6678, mac='00:00:00:00:40:01' )
    sc2 = net.addSwitch( 'sc2', listenPort=6675, mac='00:00:00:00:50:02' )
    sc3 = net.addSwitch( 'sc3', listenPort=66712, mac='00:00:00:00:60:03' )
    sc4 = net.addSwitch( 'sc4', listenPort=6679, mac='00:00:00:00:08:04' )
    sc5 = net.addSwitch( 'sc5', listenPort=6677, mac='00:00:00:00:02:05' )
    sc6 = net.addSwitch( 'sc6', listenPort=66710, mac='00:00:00:00:01:06' )
    ap0 = net.addBaseStation( 'ap0', ssid= 'ssid_0', mode= 'g', channel= '1' )

    ap1 = net.addBaseStation( 'ap1', ssid= 'ssid_1', mode= 'g', channel= '1' )
    ap2 = net.addBaseStation( 'ap2', ssid= 'ssid_2', mode= 'g', channel= '1' )
    ap3 = net.addBaseStation( 'ap3', ssid= 'ssid_3', mode= 'g', channel= '1' )
    ap4 = net.addBaseStation( 'ap4', ssid= 'ssid_4', mode= 'g', channel= '1' )
    ap5 = net.addBaseStation( 'ap5', ssid= 'ssid_5', mode= 'g', channel= '1' )
    ap6 = net.addBaseStation( 'ap6', ssid= 'ssid_6', mode= 'g', channel= '1' )

    print "*** Creating links"
    net.addLink(sc6, ap6)
    net.addLink(sc6, ap5)
    net.addLink(sc6, ap4)
    net.addLink(sc5, ap3)
    net.addLink(sc5, ap2)
    net.addLink(sc5, ap1)
    net.addLink(sc3, sc4)
    net.addLink(sc1, sc3)
    net.addLink(s21, sc3)
    net.addLink(s21, sc1)
    net.addLink(sc4, sc6)
    net.addLink(sc2, sc4)
    net.addLink(sc2, sc1)
    net.addLink(s3, sc1)
    net.addLink(sc5, ap0)
    net.addLink(sc2, sc5)
    net.addLink(s3, sc2)
    net.addLink(s0, sc2)
    net.addLink(s3, s0)

    print "*** Starting network"
    net.build()
    c0.start()
    s0.start( [c0] )
    s3.start( [c0] )
    sc2.start( [c0] )
    sc5.start( [c0] )
    sc1.start( [c0] )
    sc4.start( [c0] )
    sc6.start( [c0] )
    s21.start( [c0] )
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

