local PIXELS = 150
local phase = 0
local center_red = PIXELS * 2 / 3
local center_blue = PIXELS * 1 / 3
local maxamp = PIXELS / 6 - (PIXELS/30)
local SIN = lut.sin

local function run(wsbuf)
    wsbuf:fill(0,0,0)
    local pphase = phase * 5
    local sin_red = SIN[pphase % 256]
    local sin_blue = SIN[(pphase+32) % 256]
    pphase = nil
    local amp_red = maxamp * sin_red / 256
    local amp_blue = maxamp * sin_blue / 256

    for i = 0, amp_red do
    	wsbuf:set(center_red+i,0,255 - sin_red + amp_red - i,0)
    	wsbuf:set(center_red-i,0,255 - sin_red + amp_red - i,0)
    end

    for i = 0, amp_blue do
    	wsbuf:set(center_blue+i,0,0,255 - sin_blue + amp_blue - i)
    	wsbuf:set(center_blue-i,0,0,255 - sin_blue + amp_blue - i)
    end

    phase = (phase + 1) % 256
    return 40
end

return run
