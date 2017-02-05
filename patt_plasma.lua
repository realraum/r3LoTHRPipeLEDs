local max = math.max
local SIN = lut.sin
local band = bit.band
local function psin(x)
    return SIN[band(x, 0xff)]
end


local t = 0


local function run(wsbuf, p)
    t = t + 1
    local set = wsbuf.set
    for i = 1, wsbuf:size() do
        local s = psin(t+(i*8))
        local u = psin(-(t*2)-(i*3)+psin(i*2))
        --local v = max(0, 255-s-u) --0--psin((t+(t/2))+(i*5))
        set(wsbuf, i,s,u,0)
    end

    return 20 + ((200 * (255 - p.speed)) / 255); -- delay
end

return run
