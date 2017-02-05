
local y = 0
local dy = 1
local XO = 75
local YDIM = 50
local M = 8

local sqrt = math.sqrt
local abs = math.abs
local max = math.max
local min = math.min

local function run(wsbuf)
    if y >= YDIM or y < -YDIM then
        dy = -dy
    end
    y = y + dy

    local set = wsbuf.set

    wsbuf:fill(20, 0, 50)
    for i = 1, wsbuf:size() do
        local xx = i - XO
        local dist = sqrt(xx*xx + y*y)
        local off = dist % M
        local g, r, b = 0, 0, min(0, 50 - dist) -- underflow!
        if dist < 50 then
            if off == 0 then
                g, r = 70, 70
            end
        else
            g = off*10
            r = g
        end
        set(wsbuf, i, g, r, b)
    end
    set(wsbuf, y+XO, 0, 255, 0)

    return 70 -- delay
end

return run
