local PIXELS     = 30*5
local DEFAULT_BRIGHTNESS = 30 -- in %

local call_counter = 0

-- inspired by kitesurfer1404's WS2812F

local function run(wsbuf, hue, num_leds)
  if not (type(num_leds) == "number" and num_leds > 0 and num_leds <= 100) then
    num_leds = 4
  end
  if not (type(hue) == "number" and hue > 0 and hue <= 255) then
    hue = math.random(0,255)
  end

  if call_counter == 0 then
    wsbuf:fill(0,0,0)
    call_counter = num_leds +1
  else
  	wsbuf:set(math.random(1, PIXELS), hue2rgb(hue,100))
  end

  call_counter = call_counter -1
  return 200
end

return run