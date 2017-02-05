local PIXELS     = 30*5

-- inspired by kitesurfer1404's WS2812FX
local call_counter = 0

local function run(wsbuf, p, num_leds)
  if not (type(num_leds) == "number" and num_leds > 0 and num_leds <= 100) then
    num_leds = 3
  end

  if call_counter == 0 then
    wsbuf:fill(0,0,0)
    call_counter = num_leds +1
  else
  	wsbuf:set(math.random(1, PIXELS), hue2rgb(p:getHue(),100))
  end

  call_counter = call_counter -1
  return 50 + ((1986 * (255 - p.speed)) / 255)
end

return run