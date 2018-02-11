#!/bin/bash

IP=
PORT=

if [ "" != "$DEST_IP" ]; then
    IP=$DEST_IP
else
    IP=$1
fi

if [ "" != "$DEST_PORT" ]; then
    PORT=$DEST_PORT
else
    PORt=$2
fi

echo $

if [ "" == "$IP" or "" == "$PORT" ]; then
    echo "Put IP address and port on command line."
    echo "Example: playout.sh 127.0.0.1 5001"
    echo "Alternately, use the environment variables DEST_IP and DEST_PORT"
    exit 1
fi

DST="udp://$IP:$PORT?pkt_size=1316"

ffmpeg -stream_loop -1 -re -i video.ts -c:v copy -c:a copy -f mpegts $DST

