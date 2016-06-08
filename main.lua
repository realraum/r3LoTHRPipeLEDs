wifi.sta.connect()
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)

function stopstartup()
  tmr.unregister(0)
  print('startup aborted')
end

dofile("telnet_srv.lc")
dofile("ws2812.lc")
dofile("mqtt.lc")
setupTelnetServer()

function startup()
  stopTelnetServer()
  setupTelnetServer = nil
  stopTelnetServer = nil
  connectMQTT()
  ws2812Start()
end

tmr.alarm(0,18000,tmr.ALARM_SINGLE,startup)

