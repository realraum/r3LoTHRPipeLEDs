local BRIGHT     = 10 -- in %
local PIXELS     = 30*5

local rainbow_index = 1
local function run(wsbuf, rainbow_speed)
  if not (type(rainbow_speed) == "number" and rainbow_speed > 0) then
    rainbow_speed = 1
  end
  for pixel = 1, PIXELS do
--    tmr.wdclr()
    wsbuf:set(pixel, hue2rgb((pixel * rainbow_speed + rainbow_index) % 256))
  end
  rainbow_index = (rainbow_index + 1) % 256
  return 70
end

return run