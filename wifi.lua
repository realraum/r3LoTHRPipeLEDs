wifi.setmode(wifi.STATION)
wifi.sta.config(CONFIG.wifi)
wifi.sta.autoconnect(1)
if CONFIG.ipconf then wifi.sta.setip(CONFIG.ipconf) end

--connect to WIFI as configured in init.lua
--wifi.sta.connect()

--wait until connected to WIFI
local wifiwaittmr = tmr.create()
wifiwaittmr:alarm(1000, tmr.ALARM_AUTO, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      wifiwaittmr:stop(0)
   end
end)
