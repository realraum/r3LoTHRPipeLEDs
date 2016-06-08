BRIGHT     = 10 -- in %
-- LED_PIN    = 4       -- GPIO2
PIXELS     = 30*5
--TIME_ALARM = 25      -- 0.025 second, 40 Hz
--TIME_ALARM = 40      -- 0.20 second, 25 Hz
TIME_ALARM = 400     -- any faster and timer will fire more often that pattern_rainbow() can run

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

rainbow_speed = 2
rainbow_index = 0
wsbuf = ws2812.newBuffer(PIXELS, 3)

function pattern_rainbow()
  for pixel = 1, PIXELS do
    tmr.wdclr()
    wsbuf:set(pixel, unpack(colourWheel((rainbow_index + pixel * rainbow_speed) % 256)))
  end
  tmr.wdclr()
  rainbow_index = (rainbow_index + 3) % 256
  wsbuf:write()
end

function pattern_off()
  wsbuf:fade(2)
  wsbuf:write()
  tmr.wdclr()
end

ActivePattern = "rainbow"
LedPatterns = {off = pattern_off, rainbow = pattern_rainbow}

function ws2812Animate ()
  node.task.post(node.task.LOW_PRIORITY, LedPatterns[ActivePattern])
end

function ws2812Start ()
  ws2812.init()
  tmr.alarm(2, TIME_ALARM, 1, ws2812Animate)
end

function ws2812Stop ()
  tmr.unregister(2)
end

function ws2812Select (patt, arg)
  if LedPatterns[patt] ~= nil then
    print("Switching to pattern "..patt)
    ActivePattern = patt
    if type(arg) == "number" and patt == "rainbow" then
      rainbow_speed = arg
    end
  end
end