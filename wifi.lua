wifi.setmode(wifi.STATION)
wifi.sta.config(unpack(CONFIG.wifi))
wifi.sta.autoconnect(1)

--connect to WIFI as configured in init.lua
wifi.sta.connect()

--wait until connected to WIFI
-- FIXME: get rid of timer IDs
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)
