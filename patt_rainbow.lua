local PIXELS     = 30*5
local DEFAULT_BRIGHTNESS = 30 -- in %

local rainbow_index = 1
local function run(wsbuf, p, rainbow_speed)
  if not (rainbow_speed and rainbow_speed > 0) then
    rainbow_speed = 1
  end
  for pixel = 1, PIXELS do
    wsbuf:set(pixel, hue2rgb((pixel * rainbow_speed + rainbow_index) % 256, p.brightness))
  end
  rainbow_index = (rainbow_index + 1) % 256
  return 50
end

return run