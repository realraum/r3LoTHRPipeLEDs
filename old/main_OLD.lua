--connect to WIFI as configured in init.lua
wifi.sta.connect()

--wait until connected to WIFI
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)

--call this function to inhibit running startup() i.e. disable timer that calls startup after 18s
function stopstartup()
  tmr.unregister(0)
  print('startup aborted')
end

--load other precompiled lua files
dofile("telnet_srv.lc")
dofile("ws2812.lc")
dofile("mqtt.lc")
--start telnet console
setupTelnetServer()

--disable Telnet, connect MQTT, start Animation
--automatically runs after 18s
function startup()
  stopTelnetServer()
  setupTelnetServer = nil
  stopTelnetServer = nil
  connectMQTT()
  ws2812Start()
end

--delay for 18s then call startup() ONCE
tmr.alarm(0,18000,tmr.ALARM_SINGLE,startup)

