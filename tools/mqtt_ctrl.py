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

# listen for sensor data and forward them
if len(sys.argv) >= 3:
	client.publish(sys.argv[1], sys.argv[2])
elif len(sys.argv) == 2:
	if sys.argv[1] == "off":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "off", "arg": 0})
	elif sys.argv[1] == "rainbow":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "rainbow", "arg": 2})
	elif sys.argv[1] == "tightrainbow":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "rainbow", "arg": 10})
	elif sys.argv[1] == "spot":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "spots", "arg": 1})
	elif sys.argv[1] == "spots":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "spots", "arg": 2})
	elif sys.argv[1] == "3spots":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "spots", "arg": 2})
	elif sys.argv[1] == "2spots":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "spots", "arg": 3})
	elif sys.argv[1] == "reset":
		sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "rainbow", "arg": -1})
	else:
		print("%s is unknown cmd",sys.argv[1])
else:
	sendR3Message(client, "action/PipeLEDs/pattern",{"pattern": "off", "arg": 0})
client.loop(timeout=1.0, max_packets=1)
client.disconnect()
