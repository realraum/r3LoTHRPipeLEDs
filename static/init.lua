--init.lua is small, configured once, not automatically replaced by upload.sh
--so we don't need to store WIFI pwd on github and loads main.lc
CONFIG = dofile("config.lua")
dofile("main.lua")

