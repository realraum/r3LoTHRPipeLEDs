# r3LoTHRPipeLEDs
Experiment with NodeMCU and WS2812B LEDS

## Features

New LUA scripts can be uploaded/replaced via telnet: <tt>./upload.sh --ip 192.168.127.126</tt>

Inhibit execution of LED animation (in case of problems) by setting <tt>abort = true</tt>

    nc 192.168.127.126 telnet <<< 'abort = true'

## Problems

Memory runs out when more than 20 LEDs are used with current script.


## Todo

 - Stop playing with LUA, use [Sming](https://github.com/SmingHub) instead.
