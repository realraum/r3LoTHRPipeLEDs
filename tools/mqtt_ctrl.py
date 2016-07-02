#!/usr/bin/python3
# -*- coding: utf-8 -*-
from __future__ import with_statement
import paho.mqtt.client as mqtt
import json
import time
import sys

######## r3 ############

def sendR3Message(client, structname, datadict):
	client.publish(structname, json.dumps(datadict))

# Start zmq connection to publish / forward sensor data
client = mqtt.Client()
client.connect("mqtt.realraum.at", 1883, 60)

topic_prefix="action/PipeLEDs/"


# listen for sensor data and forward them
if len(sys.argv) < 2:
    print("Usage: <pattern|restart> [arg1 [arg2 [..]]]")
    sys.exit(1)

if sys.argv[1] == "pattern":
    data = {"pattern":"none", "arg":1}
    if len(sys.argv) > 2:
        data["pattern"] = sys.argv[2]
    if len(sys.argv) > 3:
        data["arg"] = int(sys.argv[3])
    if len(sys.argv) > 4:
        data["arg1"] = int(sys.argv[4])
    sendR3Message(client, "action/PipeLEDs/"+sys.argv[1], data)
elif sys.argv[1] == "restart" or sys.argv[1] == "reset":
    sendR3Message(client, "action/PipeLEDs/restart","")
else:
    sys.exit(1)

client.loop(timeout=1.0, max_packets=1)
client.disconnect()
