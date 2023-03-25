local function setglobal(k,v) rawset(_G, k, v) end
local function import(m, ...)     local t = assert(loadfile(m .. ".lua"))(...)     if t then         setglobal(m, t)     end end
setglobal("setglobal", setglobal)
setglobal("import", import)

node.LFS._initlfs()

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
      import "telnet"
      telnet.open()

      import "loader"
   end
end)

-- -- a global under the same name will be registered by safe.lua
-- local function errorLog(s)
--     print(s)
--     setglobal("LAST_ERROR", s)
--     return s
-- end

-- -- load the rest, safely
-- xpcall(function() import "loader" end, errorLog)
