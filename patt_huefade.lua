local curhue=0

local function run(wsbuf, p)
    wsbuf:fill(hue2rgb(curhue % 256, p.brightness))
    curhue = curhue + 1
    return 20 + ((5000 * (255 - p.speed)) / 255)
end

return run
