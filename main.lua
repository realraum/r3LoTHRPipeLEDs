wifi.sta.connect()
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)

abort = false
changefile = false
runfile="pattern_rainbow.lc"

dofile("telnet_srv.lc")
setupTelnetServer()
dofile("mqtt.lc")

function startup()
  if abort == true then
    print('startup aborted')
    return
  end
  stopTelnetServer()
  setupTelnetServer = nil
  stopTelnetServer = nil
  connectMQTT()
  connectMQTT = nil
  while abort == false do
    dofile(runfile)
    if changefile then
      changefile = false
      abort = false
    end
  end
end

tmr.alarm(0,18000,tmr.ALARM_SINGLE,startup)

