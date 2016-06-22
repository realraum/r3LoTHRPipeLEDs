
local r = 100
local d = 1

local function run(wsbuf)
    if r >= 200 or r < 5 then
        d = -d
    end
    r = r + d
    wsbuf:fill(0,r,0)

    return 100 -- delay
end

return run
