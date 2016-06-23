local PIXELS = 150
local phase = 0
local center_red = PIXELS * 2 / 3
local center_blue = PIXELS * 1 / 3
local maxamp = PIXELS / 3 - (PIXELS/30)
local SIN = lut.sin

local function run(wsbuf)
    fill(wsbuf,0,0,0)
    local set = wsbuf.set
    local amp_red = maxamp * (SIN[phase] - 127) / 256
    for i = 0, amp_red do
    	set(wsbuf, center_red+i,0,amp_red*3,0)
    	set(wsbuf, center_red-i,0,amp_red*3,0)
    end
    local amp_blue = maxamp * (SIN[(phase+16) % 256] - 127)  / 256
    for i = 0, amp_blue do
    	set(wsbuf, center_blue+i,0,0,amp_blue*3)
    	set(wsbuf, center_blue-i,0,0,amp_blue*3)
    end
    
    phase = (phase + 1) % 256
    return 60
end

return run
