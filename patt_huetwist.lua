local curhue=1
local PIXELS     = 30*5

local function run(wsbuf, p, nofade, twistwidtharg)
	local TWISTWIDTH = 16
	if type(twistwidtharg) == "number" and twistwidtharg > 1 and twistwidtharg < 128 then
		TWISTWIDTH = twistwidtharg
	end
	local huequant = 128/TWISTWIDTH
	if nofade then
		curhue = p:getHue()
	end
	for pixel = 1, (PIXELS-TWISTWIDTH)/2 do
		wsbuf:set(pixel, hue2rgb(curhue % 256, p.brightness))
	end
	for v = 1, TWISTWIDTH/2 do
		local pixel = ((PIXELS-TWISTWIDTH)/2) + v
		local ih = (curhue + (huequant*v))
		wsbuf:set(pixel, hue2rgb(ih % 256, p.brightness / v ))
	end
	for v = TWISTWIDTH/2, TWISTWIDTH do
		local pixel = ((PIXELS-TWISTWIDTH)/2) + v
		local ih = (curhue + (huequant*v))
		local bs = TWISTWIDTH-v+1
		wsbuf:set(pixel, hue2rgb(ih % 256, p.brightness / bs))
	end
	for pixel = (PIXELS+TWISTWIDTH)/2, PIXELS do
		wsbuf:set(pixel, hue2rgb((curhue + 128) % 256 , p.brightness))
	end
	curhue = (curhue +1) % 255
    return 20 + ((5000 * (255 - p.speed)) / 255)
end

return run
