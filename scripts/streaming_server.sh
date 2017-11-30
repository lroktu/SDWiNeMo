#!/bin/bash

# ./streaming_server.sh IP

cvlc /opt/video5.mp4 --sout '#rtp{dst=10.0.0.1,port=55555,mux=ts,ttl=5}'
