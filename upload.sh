#!/bin/sh

IP=$1

if [ x == "x$IP" ]; then
    echo "Need IP"
    exit 1
fi

lua tools/ledctrl.lua "$IP" *.lua
