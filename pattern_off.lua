PIXELS     = 30*5

if wsbuf then
  for div = 1, 10 do
    wsbuf:fade(2)
    wsbuf:write()
    tmr.wdclr()
  end
else
  ws2812.init()
  wsbuf = ws2812.newBuffer(PIXELS, 3)
end
wsbuf:fill(0,0,0)
wsbuf:write()
