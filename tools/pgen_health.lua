local function color(x)
    local r, g, b = 1-x, x, x*0.5
    local len = math.sqrt(r*r + g*g) -- this intentionally ignores the blue channel
    local m = 1 / len
    return r*m, g*m, b*m
end

local fl = math.floor
local INTEN = 100
local LEDS = 150

local R, G, B = {}, {}, {}
for i = 1, LEDS do
    local x = (i-1)/(LEDS-1)
    local r, g, b = color(x)
    R[i], G[i], B[i] = fl(r*INTEN), fl(g*INTEN), fl(b*INTEN)
end

print("local R = {"..table.concat(R,",").."}")
print("local G = {"..table.concat(G,",").."}")
print("local B = {"..table.concat(B,",").."}")

