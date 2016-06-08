# r3LoTHRPipeLEDs
Experiment with NodeMCU and WS2812B LEDS

## Features

New LUA scripts can be uploaded/replaced via telnet within the first 18 seconds after power on: 

    ./upload.sh --ip 192.168.127.126</tt>

Inhibit execution of LED animation (in case of problems) by calling <tt>stopstartup()</tt>

    nc 192.168.127.126 telnet <<< 'stopstartup()'

Change animation, animation parameters or switch of via MQTT:

   ./inject_mqtt_msg.py "action/PipeLEDs/pattern" '{"pattern":"rainbow","arg":2}'
   ./inject_mqtt_msg.py "action/PipeLEDs/pattern" '{"pattern":"rainbow","arg":10}'
   ./inject_mqtt_msg.py "action/PipeLEDs/pattern" '{"pattern":"off","arg":0}'

## Caveats

* <tt>pattern_rainbow()</tt> takes a long time
* <tt>node.task.post(..)</tt> needs to be used so MQTT can be used in parallel

## Todo

 - Stop playing with LUA, use [Sming](https://github.com/SmingHub) instead.
