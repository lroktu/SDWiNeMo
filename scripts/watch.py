#!/usr/bin/python
import time
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import socket
import timeit
import thread
import subprocess
import threading

os.system("sudo ifconfig s0 10.0.100.100 netmask 255.0.0.0")

class MyHandler(FileSystemEventHandler):
    '''
    def handler(self, ip, ssid, c):
        try:
            if c < 5:
                clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                clientsocket.connect((ip, 8088))
                print "Fazendo conexao a: %s,8088,(%s) \n"%(ip,ssid)
                clientsocket.send(ssid)
                clientsocket.close()
                print "Handover Realizado: (%s,%s) "%(ip,ssid)
            else:
                print "Erro persistente, encerrando thread...."
                return
        except Exception, e:
            print "Error: "+str(e)
            print "Trying again......."
            self.handler(ip,ssid,c+1)
    '''
    def try_again(self, ip, ssid, c):
        try:
            if (c < 5):
                print "Fazendo conexao a: %s,8088,(%s) \n"%(ip,ssid)
                client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                client.connect((ip,8088))
                client.send(ssid)
                client.close()
                print "Handover Realizado: (%s,%s) "%(ip,ssid)
            else:
                print "Finalizando tentativas....."
        except Exception, e:
            print "Error: %s, Trying again...."%(str(e))
            self.try_again(ip, ssid, c+1)

    def process(self, event):
        fil = os.path.basename(event.src_path)
        f = open(event.src_path, "r")
        l = f.readline()
        dados = l.split(":")
        print event.src_path
        print dados[0], dados[1]
        self.try_again(dados[0], dados[1], 0)

        '''
        clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        clientsocket.connect((ip, 8088))
        print "Fazendo conexao a: %s,8088,(%s) \n"%(ip,ssid)
        clientsocket.send(ssid)
        clientsocket.close()
        print "Handover Realizado: (%s,%s) "%(ip,ssid)
        #client_thread = threading.Thread(target= self.handler, args=(dados[0], dados[1], 0))       
        #client_thread.start()
        '''
        '''
        clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        clientsocket.connect((dados[0], 8088))
        print "Fazendo conexao a: %s,8088 \n"%(dados[0])
        clientsocket.send(dados[1])
        clientsocket.close()
        print "Handover Realizado"
        '''
    def on_modified(self, event):
        if event.is_directory:
            return
        self.process(event)


if __name__ == "__main__":
    event_handler = MyHandler()
    observer = Observer()
    observer.schedule(event_handler, path='../files/stations/', recursive=True)
    print "Watchdog Started"
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
