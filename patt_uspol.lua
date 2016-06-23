local PIXELS = 150
local phase = 0
local center_red = PIXELS * 2 / 3
local center_blue = PIXELS * 1 / 3
local maxamp = PIXELS / 3 - (PIXELS/30)
local SIN = lut.sin

local function run(wsbuf)
    fill(wsbuf,0,0,0)
    local set = wsbuf.set
    local amp_red = maxamp * SIN[phase] / 256
    for i = 1, amp_red do
    	set(wsbuf, center_red+i,0,amp_red,0)
    	set(wsbuf, center_red-i,0,amp_red,0)
    end
    local amp_blue = maxamp * SIN[phase+16]  / 256
    for i = 1, amp_blue do
    	set(wsbuf, center_blue+i,0,0,amp_blue)
    	set(wsbuf, center_blue-i,0,0,amp_blue)
    end
    
    phase = (phase + 1) % 256
    return 50
end

return run
