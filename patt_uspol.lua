local PIXELS = 150
local uspolice_phase = 0
local uspolice_centerr = PIXELS * 2 / 3
local uspolice_centerb = PIXELS * 1 / 3
local uspolice_maxamp = PIXELS / 3 - (PIXELS/30)
local SIN = lut.sin
local function uspolice(wsbuf)
    wsbuf:fill(0,0,0)
    local set = wsbuf.set
    for i = 1, uspolice_maxamp * SIN[uspolice_phase] do
    	set(wsbuf, uspolice_centerr+i,0,255-i,0)
    	set(wsbuf, uspolice_centerr-i,0,255-i,0)
    end
    for i = 1, uspolice_maxamp * SIN[uspolice_phase+4] do
    	set(wsbuf, uspolice_centerb+i,0,0,255-i)
    	set(wsbuf, uspolice_centerb-i,0,0,255-i)
    end
    
    uspolice_phase = (uspolice_phase + 1) % 256;
    return 50
end

return uspolice
