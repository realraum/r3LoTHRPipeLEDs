#!/bin/sh

IP=$1

if [ x == "x$IP" ]; then
    echo "Need IP"
    exit 1
fi

/c/Lua51/lua.exe tools/uploader.lua "$IP" *.lua
