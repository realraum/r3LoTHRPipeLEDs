
local r = 100
local d = 1

local function run(wsbuf, p)
	-- use: p:getHue(), p.brightness, p.speed
    if r >= 200 or r < 5 then
        d = -d
    end
    r = r + d
    wsbuf:fill(0,r,0)

    return 100 -- delay
end

return run
