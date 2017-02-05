local spot_index = 0

local function run(wsbuf, p, spots_count)
  if not (type(spots_count) == "number" and spots_count > 0) then
    spots_count = 1
  end
  local spots_distance = wsbuf:size()/spots_count
  wsbuf:fade(2,ws2812.FADE_OUT)
  local pos = 0
  for nspot = 0, spots_count -1 do
    pos = spot_index+1+nspot*spots_distance
    wsbuf:set(pos, 255 ,255, 255)
    if pos < wsbuf:size() then wsbuf:set(pos+1, 64 ,64, 64) end
  end
  spot_index = (spot_index + 1) % spots_distance
  return 20 + ((200 * (255 - p.speed)) / 255);
end

return run