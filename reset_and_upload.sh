#!/bin/zsh --extendedglob
local MQTTTOOL=${0:h}/tools/mqtt_ctrl.py
$MQTTTOOL reset
sleep 3
${0:h}/upload.sh "$@"
