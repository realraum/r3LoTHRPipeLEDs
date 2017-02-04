local PIXELS     = 30*5
local DEFAULT_BRIGHTNESS = 30 -- in %

local call_counter = 0

-- inspired by kitesurfer1404's WS2812FX

local function run(wsbuf, speed, bright_percent)
  if not (type(speed) == "number" and speed > 0 and speed <= 10) then
    speed = 1
  end
  if not (type(bright_percent) == "number" and bright_percent > 0 and bright_percent <= 100) then
    bright_percent = DEFAULT_BRIGHTNESS
  end

  if call_counter == 0 then
	  for pixel = 1, PIXELS do
	    wsbuf:set(pixel, hue2rgb(math.random(0,255), bright_percent))
	  end
  else
  	wsbuf:set(math.random(1, PIXELS), hue2rgb(math.random(0,255), bright_percent))
  end

  call_counter = call_counter +1
  return 2000/speed
end

return run
