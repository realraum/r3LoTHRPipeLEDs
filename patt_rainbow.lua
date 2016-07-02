local PIXELS     = 30*5
local DEFAULT_BRIGHTNESS = 30 -- in %

local rainbow_index = 1
local function run(wsbuf, rainbow_speed, bright_percent)
  if not (type(rainbow_speed) == "number" and rainbow_speed > 0) then
    rainbow_speed = 1
  end
  if not (type(bright_percent) == "number" and bright_percent > 0 and bright_percent <= 100) then
    bright_percent = DEFAULT_BRIGHTNESS
  end
  for pixel = 1, PIXELS do
--    tmr.wdclr()
    wsbuf:set(pixel, hue2rgb((pixel * rainbow_speed + rainbow_index) % 256, bright_percent))
  end
  rainbow_index = (rainbow_index + 1) % 256
  return 50
end

return run