BRIGHT     = 10 -- in %
-- LED_PIN    = 4       -- GPIO2
PIXELS     = 20
--TIME_ALARM = 25      -- 0.025 second, 40 Hz
TIME_ALARM = 40      -- 0.040 second

function colourWheel(index)
  if index < 85 then
    return {index * 3 * BRIGHT / 100, (255 - index * 3) * BRIGHT / 100, 0}
  elseif index < 170 then
    index = index - 85
    return {(255 - index * 3) * BRIGHT / 100, 0, index * 3 * BRIGHT / 100}
  else
    index = index - 170
    return {0, index * 3 * BRIGHT / 100, (255 - index * 3) * BRIGHT / 100}
  end
end

ws2812.init()

rainbow_speed = 8
rainbow_index = 0
wsbuf = ws2812.newBuffer(PIXELS, 3)

function rainbowHandler()
  for pixel = 1, PIXELS do
    colval = colourWheel((rainbow_index + pixel * rainbow_speed) % 256)
    wsbuf:set(pixel, colval[1],colval[2],colval[3])
  end
  colval = nil
  wsbuf:write()
  rainbow_index = (rainbow_index + 1) % 256
end

tmr.alarm(1, TIME_ALARM, 1, rainbowHandler)
