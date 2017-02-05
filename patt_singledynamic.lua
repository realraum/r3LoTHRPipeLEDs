local PIXELS     = 30*5

-- inspired by kitesurfer1404's WS2812FX
local call_counter = 0

local function run(wsbuf, p)
  if call_counter == 0 then
	  for pixel = 1, PIXELS do
	    wsbuf:set(pixel, hue2rgb(math.random(0,255), p.brightness))
	  end
  else
  	wsbuf:set(math.random(1, PIXELS), hue2rgb(math.random(0,255), p.brightness))
  end

  call_counter = call_counter +1
  return  10 + ((5000 * (255 - p.speed)) / 255)
end

return run
