#!/bin/zsh
setopt globcomplete extendedglob

esptool.py --chip esp8266 --port /dev/ttyUSB0 erase_flash
esptool.py --port /dev/ttyUSB0 write_flash -fm qio --verify 0x00000 ./nodemcu_img/nodemcu-*.bin
sleep 5
./tools/luac.cross -o lfs.img -f -m $((64*1024)) *.lua~init.lua~main.lua
nodemcu-tool mkfs --port=/dev/ttyUSB0
sleep 5
nodemcu-tool upload --port=/dev/ttyUSB0 lfs.img main.lua static/config.lua init.lua
