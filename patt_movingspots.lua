local PIXELS = 150
local spots_distance = PIXELS/spots_count
local spot_index = 0

local function subspot(nspot)
  wsbuf:set(nspot*spots_distance+spot_index+1,254,254,254)
  if nspot > 0 then
    subspot(nspot-1)
  end
end

local function run(wsbuf, spots_count)
  if spots_count < 1 then spots_count = 1 end
  wsbuf:fade(2,ws2812.FADE_OUT)
  --recursion because for is broken?!?
  subspot(spots_count-1)
  spot_index = (spot_index + 1) % spots_distance
  wsbuf:write()
end

return run