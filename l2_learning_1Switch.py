# Copyright 2011-2012 James McCauley
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
An L2 learning switch.

It is derived from one written live for an SDN crash course.
It is somwhat similar to NOX's pyswitch in that it installs
exact-match rules for each flow.
"""
import commands
import sys
if 'aps' in sys.modules.keys():
    del(sys.modules['aps'])

from pox.core import core
import pox.openflow.libopenflow_01 as of
from pox.lib.util import dpid_to_str
from pox.lib.util import str_to_bool
from pox.lib.addresses import IPAddr, EthAddr
import time

from pox.lib.packet.icmp import icmp
from mininet.net import Mininet
from mininet.node import  Controller, RemoteController, OVSKernelSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel
from mininet.link import TCLink
import aps
import os
import argparse


log = core.getLogger()
global poa_dict, hashes
poa_dict = {}
hash_dict = {}
# We don't want to flood immediately when a switch connects.
# Can be overriden on commandline.
_flood_delay = 0
t = 0
class LearningSwitch (object):

  def __init__ (self, connection, transparent):
    global limit
    limit = 0
    # Switch we'll be adding L2 learning switch capabilities to
    self.connection = connection
    self.transparent = transparent

    # Our table
    self.macToPort = {}

    # We want to hear PacketIn messages, so we listen
    # to the connection
    connection.addListeners(self)

    # We just use this to know when to log a helpful message
    self.hold_down_expired = _flood_delay == 0

    #log.debug("Initializing LearningSwitch, transparent=%s",
    #          str(self.transparent))


  def _handle_PacketIn (self, event):
    """
    Handle packet in messages from the switch to implement above algorithm.
    """
    global limit
    packet = event.parsed

    # Define Brq por CoS
    cosA_Brq = 2
    cosB_Brq = 1
    cosC_Brq = 0.8
    cosX_Brq = [cosA_Brq, cosB_Brq, cosC_Brq]

    if packet.find("icmp"):
        log.info("ICMP packet from %s --> %s" % (packet.src, packet.dst))
        if (IPAddr.toStr(packet.next.srcip) == "10.0.100.1") & (IPAddr.toStr(packet.next.dstip) == "10.0.0.1") & (limit == 0): # Dispara condicao para iniciar alocacao no AP1
            log.info("INICIALIZANDO ALOCACAO!!!")

            # Inicializa o cenario (No AP1) com uma quantidade N de MO nas CoS
            print "***Initializing scenario"
            cosA_MO = 5 # amount of MO in the CoSA
            cosB_MO = 5
            cosC_MO = 5
            cosX_MO = [cosC_MO, cosB_MO, cosA_MO]
            mn = 1
            sta_list = []

            i = 2   # Triggers allocation in CoSC 
            mn = 1
            limit +=1
            for mo in cosX_MO:
                for m in range(1, mo+1):
                    poa_name = "ap1"
                    poa_id = 1
                    cos_id = i
                    ap = aps.ap(poa_name, poa_id)  # get an instance of the class
                    mo_name = 'sta'+str(mn)
                    if ((ap.checkPoAResources(poa_dict.get(1), poa_id, cos_id, cosX_Brq[i], mo_name, poa_dict, cosX_Brq, hash_dict)) == True):
                        os.system("sudo echo 10.0.0."+str(mn)+":1 > ../sdwinemo/files/stations/sta"+str(mn)) # Mode os MOs, inicialmente conectados no AP0 p/ AP1
                    
                    mn += 1
                   
                i -= 1
            limit += 1

    def flood (message = None):
      """ Floods the packet """
      msg = of.ofp_packet_out()
      if time.time() - self.connection.connect_time >= _flood_delay:
        # Only flood if we've been connected for a little while...

        if self.hold_down_expired is False:
          # Oh yes it is!
          self.hold_down_expired = True
          log.info("%s: Flood hold-down expired -- flooding",
              dpid_to_str(event.dpid))

        if message is not None: log.debug(message)
        #log.debug("%i: flood %s -> %s", event.dpid,packet.src,packet.dst)
        # OFPP_FLOOD is optional; on some switches you may need to change
        # this to OFPP_ALL.
#        msg.idle_timeout = 10
#        msg.hard_timeout = 30
        msg.actions.append(of.ofp_action_output(port = of.OFPP_FLOOD))
      else:
        pass
        #log.info("Holding down flood for %s", dpid_to_str(event.dpid))
      msg.data = event.ofp
#      msg.idle_timeout = 10
#      msg.hard_timeout = 30
      msg.in_port = event.port
      self.connection.send(msg)

    def drop (duration = None):
      """
      Drops this packet and optionally installs a flow to continue
      dropping similar ones for a while
      """
          
      if duration is not None:
        if not isinstance(duration, tuple):
          duration = (duration,duration)
        msg = of.ofp_flow_mod()
        msg.match = of.ofp_match.from_packet(packet)
        msg.idle_timeout = duration[0]
        msg.hard_timeout = duration[1]
        msg.buffer_id = event.ofp.buffer_id
        self.connection.send(msg)
      elif event.ofp.buffer_id is not None:
        msg = of.ofp_packet_out()
        msg.buffer_id = event.ofp.buffer_id
        msg.in_port = event.port
        self.connection.send(msg)

    self.macToPort[packet.src] = event.port # 1

    if not self.transparent: # 2
      if packet.type == packet.LLDP_TYPE or packet.dst.isBridgeFiltered():
        drop() # 2a
        return

    if packet.dst.is_multicast:
      flood() # 3a
    else:
      if packet.dst not in self.macToPort: # 4
        flood("Port for %s unknown -- flooding" % (packet.dst,)) # 4a
      else:
        port = self.macToPort[packet.dst]
        if port == event.port: # 5
          # 5a
          log.warning("Same port for packet from %s -> %s on %s.%s.  Drop."
              % (packet.src, packet.dst, dpid_to_str(event.dpid), port))
          drop(10)
          return
        # 6
        log.debug("installing flow for %s.%i -> %s.%i" %
                  (packet.src, event.port, packet.dst, port))
        #print ("MAC TO PORT: "+str(self.macToPort))
        msg = of.ofp_flow_mod()
        msg.match = of.ofp_match.from_packet(packet, event.port)
        msg.idle_timeout = 1
        msg.hard_timeout = 1
        msg.actions.append(of.ofp_action_output(port = port))
        msg.data = event.ofp # 6a
        self.connection.send(msg)


class l2_learning (object):
  def __init__ (self, transparent):
    core.openflow.addListeners(self)
    self.transparent = transparent

  def auxiliar(self,hashes):
         v = []
         i = 0
         b = ""
         while i < 147:
                 b = b + str(hashes[i])
                 if (i == 35) | (i == 72) | (i == 109) | (i == 146):
                         v.append(b)
                         b = ""
                         i = i + 1
                 i = i + 1
         return v

  def _handle_ConnectionUp (self, event):
     global poa_dict, ap, hash_dict
     poa_name = ""
     log.debug("Connection %s" % (event.connection,))
     for m in event.connection.features.ports:
         poa_name = m.name
     poa_id = event.connection.dpid
     if poa_name == "s1":
         poa_id = 999
     poa_list = []
#     if (poa_name != "s1") & (poa_name != "ap0"):
#        hashes = commands.getoutput("sudo ovs-vsctl -- set Port "+poa_name+"-eth1 qos=@newqos"+poa_name+" -- --id=@newqos"+poa_name +" create QoS type=linux-htb other-config:max-rate=54000000 queues=0=@qa,1=@qb,2=@qc -- --id=@qa create Queue other-config:min-rate=5400000 other-config:max-rate=10800000 -- --id=@qb create Queue other-config:min-rate=2160000 other-config:max-rate=10800000 -- --id=@qc create Queue other-config:min-rate=2160000 other-config:max-rate=10800000")
#     hash_dict.update({poa_id:self.auxiliar(hashes)}) #Guardo o hash das filas criadas no ap poa_idi
     ap = aps.ap(poa_name, poa_id)
     poa_list.append(ap.createAP(poa_name, poa_id))
     poa_dict.update({poa_id:poa_list})
     LearningSwitch(event.connection, self.transparent)


def launch (transparent=False, hold_down=_flood_delay):
  """
  Starts an L2 learning switch.
  """
  try:
    global _flood_delay
    _flood_delay = int(str(hold_down), 10)
    assert _flood_delay >= 0
  except:
    raise RuntimeError("Expected hold-down to be a number")

  core.registerNew(l2_learning, str_to_bool(transparent))
