--init.lua is small, configured once, not automatically replaced by upload.sh
--so we don't need to store WIFI pwd on github and loads main.lc
wifi.setmode(wifi.STATION)
wifi.sta.config("realraum",.....)
dofile("main.lc")

