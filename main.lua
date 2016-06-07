wifi.sta.connect()
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)
dofile("telnet_srv.lc")
setupTelnetServer()

function startup()
  if abort == true then
    print('startup aborted')
    return
  end
  dofile("r3LoTHR_leds.lc")
end

abort = false
tmr.alarm(0,10000,tmr.ALARM_SINGLE,startup)

