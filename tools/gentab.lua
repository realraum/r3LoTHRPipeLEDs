local sin = math.sin
local cos = math.cos
local floor = math.floor
local PI2 = math.pi * 2

local LEDS = 150

local function mktab(f)
    local t = {}
    for i = 0, 255 do
        local x = i / 255
        local v = f(x)
        t[i] = v
    end
    return t
end

local function wrtab(t)
    return "{[0]="..t[0]..","..table.concat(t,",").."}"
end

print("local SIN = " .. wrtab(mktab(function(x) return floor(255*sin(x*PI2)) end)))
print("local SINPOS = " .. wrtab(mktab(function(x) return floor(127.5+127.5*sin(x*PI2)) end)))
