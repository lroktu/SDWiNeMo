import socket
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("-p","--port", default = "", help="porta que sera escutada")
parser.add_argument("-ip","--ip", default = "", help="ip que sera feito o bind")
args = parser.parse_args()

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serversocket.bind((args.ip,int(args.port)))
serversocket.listen(5) # become a server socket, maximum 5 connections
print "Rodando"
while True:
    connection, address = serversocket.accept()
    buf = connection.recv(64)
    if len(buf) > 0:
        print "Fazendo handover"
        os.system("bash ./scripts/handover.sh ssid_"+buf)
