local PIXELS     = 30*5
local random = math.random
-- inspired by kitesurfer1404's WS2812FX

local function run(wsbuf, p, num_leds)
  if not (type(num_leds) == "number" and num_leds > 0 and num_leds <= PIXELS) then
    num_leds = 10
  end

  wsbuf:fill(hue2rgb(p:getHue(),p.brightness))
  local whitebright = 255 * p.effectbrightness / 100

  if math.random(0,10) < 4 then
    for pixel = 1, num_leds do
      wsbuf:set(random(1, PIXELS), whitebright,whitebright,whitebright)
    end
    return 20
  end
  return 15 + ((1200 * (255 - p.speed)) / 255)
end

return run