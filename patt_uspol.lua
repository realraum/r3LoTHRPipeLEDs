local PIXELS = 150
local uspolice_phase = 0
local uspolice_centerr = PIXELS * 2 / 3
local uspolice_centerb = PIXELS * 1 / 3
local uspolice_maxamp = PIXELS / 3 - (PIXELS/30)
uspolice = function(wsbuf)
    wsbuf:fill(0,0,0);

    for i = 1, uspolice_maxamp * lut.sin(uspolice_phase) do
    	wsbuf:set(uspolice_centerr+i,0,255-i,0)
    	wsbuf:set(uspolice_centerr-i,0,255-i,0)
    end
    for i = 1, uspolice_maxamp * lut.sin(uspolice_phase+4) do
    	wsbuf:set(uspolice_centerb+i,0,0,255-i)
    	wsbuf:set(uspolice_centerb-i,0,0,255-i)
    end

    uspolice_phase = (uspolice_phase + 1) % 256;
    return 50
end

return uspolice
