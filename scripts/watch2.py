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
import argparse

#os.system("sudo ifconfig s0 10.0.100.100 netmask 255.0.0.0")

class MyHandler(FileSystemEventHandler):
	def on_modified(self, event):
		os.system("bash ./handover.sh `cat ./files/stations/sta"+str(mn)+"/sta.txt`")


parser = argparse.ArgumentParser(description='Diretorio para monitorar watch')
parser.add_argument("-dir", type=int, default='.', help='dir to monitoring')
args = parser.parse_args()

mn=args.dir

if __name__ == "__main__":
    event_handler = MyHandler()
    observer = Observer()
    observer.schedule(event_handler, path="./files/stations/sta"+str(mn)+"", recursive=True)
    print "Watchdog Started"
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
