#!/bin/bash

if [ "" == "$2" ]; then
    echo "Put IP address and port on command line."
    echo "Example: playout.sh 127.0.0.1 5001"
    exit 1
fi

IP=$1
PORT=$2
DST="udp://$IP:$PORT?pkt_size=1316"

ffmpeg -stream_loop -1 -re -i video.ts -c:v copy -c:a copy -f mpegts $DST

